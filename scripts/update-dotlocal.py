#!/usr/bin/env python3
"""Update the formula only from the authenticated stable release channel."""
import argparse
import base64
import hashlib
import json
import pathlib
import re
import subprocess
import tempfile
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parent.parent
BASE = "https://raw.githubusercontent.com/euforicio/dotlocal/channels/stable.json"
TARGETS = ("aarch64-macos", "x86_64-macos", "aarch64-linux", "x86_64-linux")


def download(url, limit):
    with urllib.request.urlopen(url, timeout=60) as response:
        if not response.url.startswith("https://"):
            raise ValueError("HTTPS required")
        body = response.read(limit + 1)
    if len(body) > limit:
        raise ValueError("Download exceeds limit")
    return body


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--previous", action="store_true", help="Render the previous signed stable release for upgrade testing")
    parser.add_argument("--output", type=pathlib.Path)
    options = parser.parse_args()
    body, signature = download(BASE, 65536), download(BASE + ".sig", 256)
    key = base64.b64decode((ROOT / "scripts/dotlocal-public-key").read_text().strip(), validate=True)
    sig = base64.b64decode(signature.strip(), validate=True)
    if len(key) != 32 or len(sig) != 64:
        raise ValueError("Invalid Ed25519 key or signature")
    with tempfile.TemporaryDirectory() as temporary:
        work = pathlib.Path(temporary)
        (work / "manifest").write_bytes(body)
        (work / "signature").write_bytes(sig)
        (work / "key.der").write_bytes(bytes.fromhex("302a300506032b6570032100") + key)
        subprocess.run(["openssl", "pkeyutl", "-verify", "-pubin", "-keyform", "DER", "-inkey", str(work / "key.der"), "-rawin", "-in", str(work / "manifest"), "-sigfile", str(work / "signature")], check=True)
    manifest = json.loads(body)
    if manifest["schema"] != 1 or manifest["channel"] != "stable":
        raise ValueError("Not a stable channel manifest")
    release = manifest["releases"][min(1, len(manifest["releases"]) - 1) if options.previous else 0]
    version = release["version"]
    if not re.fullmatch(r"(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)", version):
        raise ValueError("Invalid stable version")
    if not re.fullmatch(r"[0-9a-f]{40}", release["commit"]):
        raise ValueError("Invalid source commit")
    assets = release["assets"]
    if set(assets) != set(TARGETS):
        raise ValueError("All four release targets are required")
    for target in TARGETS:
        arch, platform = target.split("-")
        url = f"https://github.com/euforicio/dotlocal/releases/download/v{version}/dotlocal-{version}-{platform}-{arch}.tar.gz"
        if assets[target]["url"] != url or not re.fullmatch(r"[0-9a-f]{64}", assets[target]["sha256"]):
            raise ValueError("Invalid release asset")
    formula = options.output or ROOT / "Formula/dotlocal.rb"
    previous = formula.read_text() if formula.exists() else ""
    current = re.search(r'/releases/download/v([0-9.]+)/', previous)
    if current and not options.output:
        old = tuple(map(int, current[1].split(".")))
        new = tuple(map(int, version.split(".")))
        if new < old:
            raise ValueError("Refusing formula downgrade")
        if new == old:
            # Immutable releases must retain the formula's published checksums.
            for target in TARGETS:
                if assets[target]["sha256"] not in previous:
                    raise ValueError("Published release checksum changed")
            print(f"dotlocal {version}: no change")
            return
    for target in TARGETS:
        archive = download(assets[target]["url"], 64 << 20)
        if hashlib.sha256(archive).hexdigest() != assets[target]["sha256"]:
            raise ValueError(f"Archive checksum mismatch: {target}")
    lines = ["class Dotlocal < Formula", '  desc "Local HTTPS routing for any server runtime"', '  homepage "https://github.com/euforicio/dotlocal"', '  license "MIT"', ""]
    for platform, brew_platform in (("macos", "macos"), ("linux", "linux")):
        lines.append(f"  on_{brew_platform} do")
        if platform == "macos":
            lines.extend(["    depends_on macos: :ventura", ""])
        for arch, brew_arch in (("aarch64", "arm"), ("x86_64", "intel")):
            asset = assets[f"{arch}-{platform}"]
            lines.extend([f"    on_{brew_arch} do", f'      url "{asset["url"]}"', f'      sha256 "{asset["sha256"]}"', "    end", ""])
        lines[-1] = "  end"
        lines.append("")
    if tuple(map(int, version.split("."))) >= (0, 1, 2):
        lines.extend([
            "  def install", '    libexec.install "dotlocal"',
            '    (bin/"dotlocal").write <<~SH', '      #!/bin/sh',
            '      exec "#{libexec}/dotlocal" __brew-launch "$@"', '    SH', '    (bin/"dotlocal").chmod 0755', '  end', "",
            "  def caveats", "    <<~EOS",
            "      CLI and daemon retain signed automatic updates.",
            "      Brew owns the launcher and bundle; the CLI updates ~/.dotlocal/bin/dotlocal.",
            "      brew info reports the bundle version; dotlocal version reports the runtime.",
            "      Newer Brew bundles advance the runtime; pins and the selected nightly channel are preserved.",
            "      Set up privileged macOS listeners and certificate trust: dotlocal init", "",
            "      brew uninstall removes the launcher and bundle. User state and the explicitly",
            "      installed daemon remain; remove the daemon with sudo dotlocal uninstall first.",
            "    EOS", "  end", "", "  test do",
            '    assert_equal "#{version}\\n", shell_output("#{bin}/dotlocal version")',
            '    assert_path_exists testpath/".dotlocal/bin/dotlocal"',
            '    system bin/"dotlocal", "--help"',
            '    system bin/"dotlocal", "update", "--check"', "  end", "end", "",
        ])
    else:
        # Older authenticated releases are used only as the upgrade baseline.
        lines.extend(["  def install", '    bin.install "dotlocal"', "  end", "", "  test do",
                      '    assert_equal "#{version}\\n", shell_output("#{bin}/dotlocal version")',
                      '    system bin/"dotlocal", "--help"', "  end", "end", ""])
    formula.write_text("\n".join(lines))
    print(f"Updated dotlocal to {version} from {release['commit']}")


if __name__ == "__main__":
    main()
