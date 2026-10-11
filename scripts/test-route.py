#!/usr/bin/env python3
"""Verify the installed CLI with a real local upstream and strict TLS/H2."""
import http.server
import os
import pathlib
import socket
import subprocess
import sys
import tempfile
import threading
import time


def run(args, env):
    return subprocess.check_output(args, env=env, text=True).strip()


class Handler(http.server.BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"

    def do_GET(self):
        body = b"dotlocal brew acceptance"
        self.send_response(200)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


with tempfile.TemporaryDirectory(prefix="dlr-", dir="/tmp") as directory:
    state = pathlib.Path(directory)
    env = {key: value for key, value in os.environ.items() if not key.startswith("DOTLOCAL_")}
    env.update(DOTLOCAL_STATE_DIR=str(state), DOTLOCAL_SOCKET=str(state / "management.sock"), DOTLOCAL_AUTO_UPDATE="0")
    upstream = http.server.ThreadingHTTPServer(("127.0.0.1", 0), Handler)
    threading.Thread(target=upstream.serve_forever, daemon=True).start()
    with socket.socket() as listener:
        listener.bind(("127.0.0.1", 0))
        port = listener.getsockname()[1]
    binary = sys.argv[1]
    with (state / "daemon.log").open("w+") as log:
        daemon = subprocess.Popen([binary, "daemon", "--state-dir", str(state), "--management-socket", env["DOTLOCAL_SOCKET"], "--listen", f"127.0.0.1:{port}"], env=env, stdout=log, stderr=log)
        try:
            for _ in range(300):
                if daemon.poll() is not None:
                    log.seek(0)
                    raise RuntimeError(log.read())
                if (state / "management.sock").exists():
                    ready = subprocess.run([binary, "status"], env=env, capture_output=True)
                    if ready.returncode == 0:
                        break
                time.sleep(0.1)
            else:
                raise RuntimeError("Daemon readiness timeout")
            run([binary, "alias", "brew-check", str(upstream.server_address[1])], env)
            for option, expected in (("--http1.1", "1.1"), ("--http2", "2")):
                output = run(["curl", "--fail", "--silent", "--show-error", "--noproxy", "*", option, "--cacert", str(state / "pki/ca.pem"), "--resolve", f"brew-check.local:{port}:127.0.0.1", f"https://brew-check.local:{port}/", "--write-out", "\n%{http_version}"], env)
                assert output == f"dotlocal brew acceptance\n{expected}", output
            print("PASS installed Brew CLI, real upstream, strict HTTPS and HTTP/2")
        finally:
            daemon.terminate()
            daemon.wait(timeout=10)
            upstream.shutdown()
