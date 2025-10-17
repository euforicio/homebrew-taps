# Homebrew Formula for wikimd
# Documentation: https://docs.brew.sh/Formula-Cookbook

class Wikimd < Formula
  desc "Local-first Markdown wiki with live file watching and elegant UI"
  homepage "https://github.com/euforicio/wikimd"
  version "0.1.0" # UPDATE THIS with each release
  license "MIT"

  # Platform-specific binary downloads
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Darwin_arm64.tar.gz"
      sha256 "782fbf436bf42ccf55064f3fd57cc45dfa5c5b5bd1b6065165d17554f88edb8b"
    else
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Darwin_x86_64.tar.gz"
      sha256 "c8380e12fdf65343a39bc4f4b2c64ded41713611921c51ccdac2e0749ae78c52"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Linux_arm64.tar.gz"
      sha256 "3bc30048f86a85a075e8c46bbb9f52b3547366eb635a6b4a3e88744344432337"
    else
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Linux_x86_64.tar.gz"
      sha256 "02c86ddab0c7aedb7b3f55e2984cc01cde9014d0b1695b23816cffc39312a793"
    end
  end

  # Dependencies
  depends_on "ripgrep" # Required for search functionality
  uses_from_macos "curl"

  def install
    bin.install "wikimd"
  end

  test do
    # Test that binary runs and reports version
    assert_match version.to_s, shell_output("#{bin}/wikimd --version")

    # Test basic functionality
    system "#{bin}/wikimd", "--help"
  end
end
