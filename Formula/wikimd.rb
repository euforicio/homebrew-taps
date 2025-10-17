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
      sha256 "PLACEHOLDER_ARM64_MACOS_CHECKSUM" # UPDATE THIS after creating release
    else
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Darwin_x86_64.tar.gz"
      sha256 "PLACEHOLDER_AMD64_MACOS_CHECKSUM" # UPDATE THIS after creating release
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Linux_arm64.tar.gz"
      sha256 "PLACEHOLDER_ARM64_LINUX_CHECKSUM" # UPDATE THIS after creating release
    else
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Linux_x86_64.tar.gz"
      sha256 "PLACEHOLDER_AMD64_LINUX_CHECKSUM" # UPDATE THIS after creating release
    end
  end

  # Optional dependencies
  uses_from_macos "curl"

  # Recommend ripgrep for enhanced search functionality
  def install
    bin.install "wikimd"
  end

  test do
    # Test that binary runs and reports version
    assert_match version.to_s, shell_output("#{bin}/wikimd --version")

    # Test basic functionality
    system "#{bin}/wikimd", "--help"
  end

  def caveats
    <<~EOS
      wikimd has been installed!

      For enhanced search functionality, install ripgrep:
        brew install ripgrep

      Quick start:
        # Start wiki server in current directory
        wikimd

        # Start wiki with specific directory
        wikimd --root ~/my-wiki

      For more options, run:
        wikimd --help
    EOS
  end
end
