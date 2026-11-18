#!/usr/bin/env python3
"""Keep every cask in this tap on its app's latest GitHub release.

For each cask below: read the app repo's latest (non-draft, non-prerelease)
release, find the asset the cask downloads, hash it, and rewrite the cask's
`version` and `sha256` lines when either changed. Nothing else in the cask is
touched. Prints one line per cask; exits 0 whether or not anything changed.

Run by .github/workflows/bump-casks.yml on a schedule and on demand. Uses only
the public GitHub API, so the workflow's own GITHUB_TOKEN is enough.
"""
import hashlib
import json
import os
import pathlib
import re
import sys
import urllib.request

# cask file → (GitHub repo, asset name; {v} is the version without the leading "v")
CASKS = {
    "clipstack":   ("iamzifei/clipstack",   "ClipStack-{v}.dmg"),
    "candela":     ("iamzifei/Candela",     "Candela.dmg"),
    "audioswitch": ("iamzifei/audioswitch", "AudioSwitch.zip"),
    "inkstone":    ("iamzifei/inkstone",    "Inkstone-{v}.dmg"),
    "veil":        ("iamzifei/veil",        "Veil.dmg"),
    "tapper":      ("iamzifei/tapper",      "Tapper.dmg"),
}

ROOT = pathlib.Path(__file__).resolve().parents[2]
TOKEN = os.environ.get("GITHUB_TOKEN", "")


def get(url, accept="application/vnd.github+json"):
    req = urllib.request.Request(url, headers={"Accept": accept, "User-Agent": "tap-bump"})
    if TOKEN and url.startswith("https://api.github.com"):
        req.add_header("Authorization", f"Bearer {TOKEN}")
    with urllib.request.urlopen(req, timeout=120) as r:
        return r.read()


def main():
    changed = []
    for name, (repo, pattern) in CASKS.items():
        path = ROOT / "Casks" / f"{name}.rb"
        text = path.read_text()
        cur_v = re.search(r'^\s*version "([^"]+)"', text, re.M).group(1)
        cur_sha = re.search(r'^\s*sha256 "([0-9a-f]{64})"', text, re.M).group(1)
        rel = json.loads(get(f"https://api.github.com/repos/{repo}/releases/latest"))
        v = rel["tag_name"].lstrip("v")
        want = pattern.format(v=v)
        asset = next((a for a in rel.get("assets", []) if a["name"] == want), None)
        if asset is None:
            print(f"{name}: latest release {rel['tag_name']} has no asset {want} — skipped")
            continue
        sha = hashlib.sha256(get(asset["browser_download_url"], "application/octet-stream")).hexdigest()
        if v == cur_v and sha == cur_sha:
            print(f"{name}: up to date ({v})")
            continue
        text = re.sub(r'^(\s*version ")[^"]+(")', rf'\g<1>{v}\2', text, count=1, flags=re.M)
        text = re.sub(r'^(\s*sha256 ")[0-9a-f]{64}(")', rf'\g<1>{sha}\2', text, count=1, flags=re.M)
        path.write_text(text)
        changed.append(f"{name} {v}")
        print(f"{name}: {cur_v} → {v} (sha256 {sha[:12]}…)")
    out = os.environ.get("GITHUB_OUTPUT")
    if out:
        with open(out, "a") as f:
            f.write(f"message={', '.join(changed)}\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
