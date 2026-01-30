class Wikimd < Formula
  desc "Local-first Markdown wiki with live file watching and elegant UI"
  homepage "https://github.com/euforicio/wikimd"
  version "0.2.2" # UPDATE THIS with each release
  license "MIT"

  depends_on "ripgrep"
  uses_from_macos "curl"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Darwin_arm64.tar.gz"
      sha256 "8ddd8fe60efcf7185163bdc2cd25a65e4800efacd2ce9ce027b108728f19b396"
    else
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Darwin_x86_64.tar.gz"
      sha256 "4ddcb5573f00bb5910b3b527d0b7df501f6d5cc3384832b261c0ee94572dd64f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Linux_arm64.tar.gz"
      sha256 "f9531aed016494b5e8f9c60be2e2dab500ac2e7a60a60fd273cf0ba884406db4"
    else
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Linux_x86_64.tar.gz"
      sha256 "7e5913c83a8094e69b77a2499b3c81ace5e578292adf14d63143c20c891b764a"
    end
  end

  def install
    bin.install "wikimd"
  end

  test do
    exe = bin/"wikimd"
    assert_match version.to_s, shell_output("#{exe} --version")
    system exe, "--help"
  end
end
