class Wikimd < Formula
  desc "Local-first Markdown wiki with live file watching and elegant UI"
  homepage "https://github.com/euforicio/wikimd"
  version "0.2.1" # UPDATE THIS with each release
  license "MIT"

  depends_on "ripgrep"
  uses_from_macos "curl"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Darwin_arm64.tar.gz"
      sha256 "8ddd8fe60efcf7185163bdc2cd25a65e4800efacd2ce9ce027b108728f19b396"
    else
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Darwin_x86_64.tar.gz"
      sha256 "36864c81f55fa7eaa65c3b4c0c469cb8cd145cd3ac3e6180156be705f3a336ad"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Linux_arm64.tar.gz"
      sha256 "2eab576028540ddbcd27bdbb5bf4416a03ee460b88945217a3f3e10d57f85d27"
    else
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Linux_x86_64.tar.gz"
      sha256 "a8b22c307321f471892bf9c240258e28af3a34c0b48f2fab88a243b08db203b7"
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
