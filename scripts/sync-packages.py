#!/usr/bin/env python3
"""Copy the dependency versions from Package.swift into project.yml.

Package.swift is where versions are set (Dependabot updates it); project.yml is
what the app is built from. Run before xcodegen. --check exits 1 if they differ.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
# Package names project.yml uses for each repository.
NAMES = {"GRDB.swift": "GRDB", "argmax-oss-swift": "WhisperKit",
         "FluidAudio": "FluidAudio", "Sparkle": "Sparkle"}


def packages_block() -> str:
    swift = (ROOT / "Package.swift").read_text()
    lines = ["packages:"]
    for url, minor, version in re.findall(
            r'\.package\(url: "([^"]+)", (\.upToNextMinor\()?from: "([^"]+)"\)?\)', swift):
        repo = url.rstrip("/").split("/")[-1].removesuffix(".git")
        if repo not in NAMES:
            sys.exit(f"sync-packages: no project.yml name for {url}; add it to NAMES")
        lines += [f"  {NAMES[repo]}:", f"    url: {url}",
                  f"    {'minorVersion' if minor else 'majorVersion'}: {version}"]
    if len(lines) - 1 != 3 * len(NAMES):
        sys.exit("sync-packages: Package.swift does not list every app package")
    return "\n".join(lines) + "\n"


def main() -> None:
    path = ROOT / "project.yml"
    text = path.read_text()
    synced = re.sub(r"^packages:\n(?:  .*\n)+", packages_block(), text, count=1, flags=re.M)
    if "--check" in sys.argv:
        if synced != text:
            sys.exit("project.yml packages differ from Package.swift: run scripts/sync-packages.py")
        return
    path.write_text(synced)


main()
