class Dotlocal < Formula
  desc "Local HTTPS routing for any server runtime"
  homepage "https://github.com/euforicio/dotlocal"
  license "MIT"

  on_macos do
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/euforicio/dotlocal/releases/download/v0.1.3/dotlocal-0.1.3-macos-aarch64.tar.gz"
      sha256 "b13dd0d593c1ba1f638182a20c1141bed24c3d8b3c5fb886ef98ab06a4cbaab3"
    end

    on_intel do
      url "https://github.com/euforicio/dotlocal/releases/download/v0.1.3/dotlocal-0.1.3-macos-x86_64.tar.gz"
      sha256 "d725f5380b117894baede89e76bf389976788bdd8973e0fe86ef1030607dfc28"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/euforicio/dotlocal/releases/download/v0.1.3/dotlocal-0.1.3-linux-aarch64.tar.gz"
      sha256 "4083687f61136fcfeb7b0f0f54a9ae11bf856b9d9279ab274db4e3777e9480f1"
    end

    on_intel do
      url "https://github.com/euforicio/dotlocal/releases/download/v0.1.3/dotlocal-0.1.3-linux-x86_64.tar.gz"
      sha256 "296a66d53e4f3bd55e08cbb5131641b0cad95ed0762fecdec4999a3bbadb1f54"
    end
  end

  def install
    libexec.install "dotlocal"
    (bin/"dotlocal").write <<~SH
      #!/bin/sh
      exec "#{libexec}/dotlocal" __brew-launch "$@"
    SH
    (bin/"dotlocal").chmod 0755
  end

  def caveats
    <<~EOS
      CLI and daemon retain signed automatic updates.
      Brew owns the launcher and bundle; the CLI updates ~/.dotlocal/bin/dotlocal.
      brew info reports the bundle version; dotlocal version reports the runtime.
      Newer Brew bundles advance the runtime; pins and the selected nightly channel are preserved.
      Set up privileged macOS listeners and certificate trust: dotlocal init

      brew uninstall removes the launcher and bundle. User state and the explicitly
      installed daemon remain; remove the daemon with sudo dotlocal uninstall first.
    EOS
  end

  test do
    assert_equal "#{version}\n", shell_output("#{bin}/dotlocal version")
    assert_path_exists testpath/".dotlocal/bin/dotlocal"
    system bin/"dotlocal", "--help"
    system bin/"dotlocal", "update", "--check"
  end
end
