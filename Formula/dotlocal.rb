class Dotlocal < Formula
  desc "Local HTTPS routing for any server runtime"
  homepage "https://github.com/euforicio/dotlocal"
  license "MIT"

  on_macos do
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/euforicio/dotlocal/releases/download/v0.1.2/dotlocal-0.1.2-macos-aarch64.tar.gz"
      sha256 "e934f600190b482464d2ab62fcd1c1245883535d09068536dca62b51bb8bf5b3"
    end

    on_intel do
      url "https://github.com/euforicio/dotlocal/releases/download/v0.1.2/dotlocal-0.1.2-macos-x86_64.tar.gz"
      sha256 "12414389e7fd0dfc72bf057626c9c5765b8d604d574fe25b00a5114e8e029acc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/euforicio/dotlocal/releases/download/v0.1.2/dotlocal-0.1.2-linux-aarch64.tar.gz"
      sha256 "cf119c7b1a6b0c6b7f12c22b8c4d54ed63b68d130dc5232565b9786327024167"
    end

    on_intel do
      url "https://github.com/euforicio/dotlocal/releases/download/v0.1.2/dotlocal-0.1.2-linux-x86_64.tar.gz"
      sha256 "f9bb15440e6603e95e5c6f9528c6a7307e425247abed42c3ca01841f34600e5b"
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
