class Wikimd < Formula
  desc "Local-first Markdown wiki with live file watching and elegant UI"
  homepage "https://github.com/euforicio/wikimd"
  version "0.2.0" # UPDATE THIS with each release
  license "MIT"

  depends_on "ripgrep"
  uses_from_macos "curl"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Darwin_arm64.tar.gz"
      sha256 "8ddd8fe60efcf7185163bdc2cd25a65e4800efacd2ce9ce027b108728f19b396"
    else
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Darwin_x86_64.tar.gz"
      sha256 "8ed44ccea67d491eb6e2dab9a200b4676ba846fc6c01ae7bccf44643e8591311"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Linux_arm64.tar.gz"
      sha256 "ea6e6027b7029b8b19dd0ccabce9ba19d37999e81e4911c43f52f3fd7cccfff9"
    else
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Linux_x86_64.tar.gz"
      sha256 "b2e46c63467c80e5ba41d2fd6babc849153c1350ef1e74135ef3b9a5f7212e9a"
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
