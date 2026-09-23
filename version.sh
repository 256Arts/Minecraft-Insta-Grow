# Sourced by the build scripts. fabric/fabric.mod.json is the single source of truth
# for the pack version; the release tag is checked against it in CI.
version=$(sed -n 's/.*"version": "\(.*\)".*/\1/p' fabric/fabric.mod.json | head -1)
# The newest Minecraft version the pack is tested on. It suffixes the artifact names and
# is the game version CI publishes against; bump it with pack.mcmeta's max_format.
minecraft=26.3
