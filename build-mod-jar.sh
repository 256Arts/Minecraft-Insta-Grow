#!/bin/sh
# Packages the data pack as a mod jar for both Fabric and NeoForge at once. Either
# loader reads a mod jar's data/ directory as an always-on data pack, so the mod needs
# no Java and no compiler — it is the same files in a different wrapper — and each
# loader ignores the other's metadata file, so one jar covers both.
set -eu

. ./pack-lib.sh

stage_pack mod
cp fabric/fabric.mod.json "$staging/"
mkdir -p "$staging/META-INF"
sed "s/@VERSION@/$version/" neoforge/neoforge.mods.toml > "$staging/META-INF/neoforge.mods.toml"
pack_archive "insta-grow-$version.jar"
