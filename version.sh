# Sourced by the build scripts. fabric/fabric.mod.json is the single source of truth
# for the pack version; the release tag is checked against it in CI.
version=$(sed -n 's/.*"version": "\(.*\)".*/\1/p' fabric/fabric.mod.json | head -1)
