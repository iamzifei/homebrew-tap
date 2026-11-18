# Homebrew cask for Tapper.
#
# Tapper updates itself with Sparkle once installed (`auto_updates true`).
# Bump `version` and `sha256` here when a release ships.
cask "tapper" do
  version "1.1.0"
  sha256 "56be8adb49a25424cd2d1ff759b6b1947365031f5b7370848275e50d2004efea"

  url "https://github.com/iamzifei/tapper/releases/download/v#{version}/Tapper.dmg"
  name "Tapper"
  desc "Cartoon glove pointer on a long stick for demos and screen recordings"
  homepage "https://jamesai.dev/tapper/"

  livecheck do
    url "https://raw.githubusercontent.com/iamzifei/tapper/main/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  # Universal (Apple silicon and Intel), macOS 14 (Sonoma) or later.
  depends_on macos: :sonoma

  app "Tapper.app"

  zap trash: "~/Library/Preferences/dev.jamesai.tapper.plist"
end
