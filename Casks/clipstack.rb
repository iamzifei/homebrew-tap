# Homebrew cask for ClipStack — clipboard history in the macOS menu bar.
#
# ClipStack updates itself with Sparkle once installed (`auto_updates true`), so
# a cask that lags a release still lands people on the newest build after the
# first launch. Bump `version` and `sha256` here when a release ships.
cask "clipstack" do
  version "1.9.1"
  sha256 "791f904ec47ccd105c1da07587d3024d97a654e4056854666ae29aa2338daddf"

  url "https://github.com/iamzifei/clipstack/releases/download/v#{version}/ClipStack-#{version}.dmg"
  name "ClipStack"
  desc "Menu bar clipboard history: press Shift-Cmd-V to search and paste past copies"
  homepage "https://getclipstack.app/"

  # The same feed the app's Sparkle updater reads.
  livecheck do
    url "https://raw.githubusercontent.com/iamzifei/clipstack/main/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  # Apple silicon only, macOS 13 (Ventura) or later.
  depends_on arch: :arm64
  depends_on macos: :ventura

  app "ClipStack.app"

  zap trash: [
    "~/Library/Application Support/ClipStack",
    "~/Library/Preferences/com.james.ClipStack.plist",
  ]
end
