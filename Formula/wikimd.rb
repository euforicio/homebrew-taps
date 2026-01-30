class Wikimd < Formula
  desc "Local-first Markdown wiki with live file watching and elegant UI"
  homepage "https://github.com/euforicio/wikimd"
  version "0.2.3" # UPDATE THIS with each release
  license "MIT"

  depends_on "ripgrep"
  uses_from_macos "curl"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Darwin_arm64.tar.gz"
      sha256 "3a22aeda3c4545fd3972a39a3977650021015e9bb8f491738778ecac47e5c667"
    else
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Darwin_x86_64.tar.gz"
      sha256 "14f32d632abe2f8f7f5007913d8dea8da70c69033e6f3720eb2961646987d3ac"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Linux_arm64.tar.gz"
      sha256 "760f904252bcf813e7009a32d40f252683bd31a55540b7e4fb83f9c2aa103a51"
    else
      url "https://github.com/euforicio/wikimd/releases/download/v#{version}/wikimd_#{version}_Linux_x86_64.tar.gz"
      sha256 "4627747598b215f93385f1499a357181a21d4a6a87cb67077ae4938e551ea0ae"
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
