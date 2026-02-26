cask "scratchpad" do
  version "0.1.0"
  sha256 :no_check

  url "https://github.com/euforicio/scratchpad/releases/download/v#{version}/Scratchpad-#{version}.dmg"
  name "Scratchpad"
  desc "Native scratchpad and clipboard manager for macOS"
  homepage "https://github.com/euforicio/scratchpad"

  depends_on macos: ">= :sonoma"

  app "Scratchpad.app"

  zap trash: [
    "~/Library/Application Support/io.euforic.scratchpad",
    "~/Library/Caches/io.euforic.scratchpad",
    "~/Library/Cookies/io.euforic.scratchpad.binarycookies",
    "~/Library/Preferences/io.euforic.scratchpad.plist",
    "~/Library/Saved Application State/io.euforic.scratchpad.savedState",
  ]
end
