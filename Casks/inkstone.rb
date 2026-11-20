# Homebrew cask for Inkstone — Markdown notes that stay plain files in your folder.
#
# Inkstone updates itself with Sparkle once installed (`auto_updates true`).
# Bump `version` and `sha256` here when a release ships.
cask "inkstone" do
  version "0.5.3"
  sha256 "da42e30effc3dacc0c2b3baaa41b77993f3d80a432b78bef0ab63c78ded3c483"

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
