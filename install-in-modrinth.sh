#!/bin/sh
# Builds the mod jar and installs it into a Modrinth App instance, replacing any
# previously installed copy. Run from the repo root. macOS only.
set -eu

profile="${1:-Latest Fabric}"
mods="$HOME/Library/Application Support/ModrinthApp/profiles/$profile/mods"

[ -d "$mods" ] || { echo "no mods dir: $mods" >&2; exit 1; }

sh build-mod-jar.sh

. ./version.sh
jar="build/insta-grow-$version.jar"

# Drop every old build, including .disabled ones, so no duplicate mod id loads.
find "$mods" -maxdepth 1 \( -name 'insta-grow-*.jar' -o -name 'insta-grow-*.jar.disabled' \) \
     -exec rm -f {} +

cp "$jar" "$mods/"
echo "installed $(basename "$jar") into $mods"
