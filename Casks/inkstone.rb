# Homebrew cask for Inkstone — Markdown notes that stay plain files in your folder.
#
# Inkstone updates itself with Sparkle once installed (`auto_updates true`).
# Bump `version` and `sha256` here when a release ships.
cask "inkstone" do
  version "0.5.1"
  sha256 "da341a84612a798c67abc7eb913d7b20eaf1669ca117d2dab3010bb3c0901080"

  url "https://github.com/iamzifei/inkstone/releases/download/v#{version}/Inkstone-#{version}.dmg"
  name "Inkstone"
  desc "Markdown notes as plain files, with wikilinks, a graph and a canvas"
  homepage "https://inkslab.app/"

  livecheck do
    url "https://inkslab.app/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  # Built against the macOS 26 SDK; universal (Apple silicon and Intel).
  depends_on macos: :tahoe

  app "Inkstone.app"
end
