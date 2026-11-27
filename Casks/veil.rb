# Homebrew cask for Veil.
#
# Veil updates itself with Sparkle once installed (`auto_updates true`).
# Bump `version` and `sha256` here when a release ships.
cask "veil" do
  version "1.2.1"
  sha256 "c7e6402864c20657d27882eedf04b3741e044bcc9e013a6c714d9ad9799235d9"

  url "https://github.com/iamzifei/veil/releases/download/v#{version}/Veil.dmg"
  name "Veil"
  desc "Keeps the window you are working in sharp and blurs everything behind it"
  homepage "https://jamesai.dev/veil/"

  livecheck do
    url "https://raw.githubusercontent.com/iamzifei/veil/main/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  # Universal (Apple silicon and Intel), macOS 14 (Sonoma) or later.
  depends_on macos: :sonoma

  app "Veil.app"

  zap trash: "~/Library/Preferences/dev.jamesai.veil.plist"
end
