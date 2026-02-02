class Wikimd < Formula
  desc "Local-first Markdown wiki with live file watching and elegant UI"
  homepage "https://github.com/euforicio/wikimd"
  version "0.2.4" # UPDATE THIS with each release
  license "MIT"

  depends_on "ripgrep"
  uses_from_macos "curl"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Darwin_arm64.tar.gz"
      sha256 "cf8f777b8a4fb5aa62e2c09431be72e03f0a775ccd71c1066c9ca58b882a8373"
    else
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Darwin_x86_64.tar.gz"
      sha256 "d539a4a76373212987e1e418e0c090dc2975d605811f96f78c80862450131cd9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Linux_arm64.tar.gz"
      sha256 "d8b367350bb925ced09d189f21c1c8cda19dca250c2906b3aafb9e4d3ccf165c"
    else
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Linux_x86_64.tar.gz"
      sha256 "57c92e7bbb304014cb6556a580266ec9d57e8e6311b67f7eb9d33973467f4752"
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
