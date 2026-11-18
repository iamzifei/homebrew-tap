# Homebrew cask for AudioSwitch — every audio input and output in one menu-bar panel.
#
# AudioSwitch updates itself with Sparkle once installed (`auto_updates true`).
# Bump `version` and `sha256` here when a release ships.
cask "audioswitch" do
  version "1.5.2"
  sha256 "a37ff9300f3031434c205c16379de491795c1d589ac571d85b9245a604c05808"

  url "https://github.com/iamzifei/audioswitch/releases/download/v#{version}/AudioSwitch.zip"
  name "AudioSwitch"
  desc "Menu bar audio switcher with a live microphone meter"
  homepage "https://audioswitch.dev/"

  livecheck do
    url "https://raw.githubusercontent.com/iamzifei/audioswitch/main/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  # Apple silicon only, macOS 14 (Sonoma) or later.
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "AudioSwitch.app"

  zap trash: "~/Library/Preferences/com.iamzifei.audioswitch.plist"
end
