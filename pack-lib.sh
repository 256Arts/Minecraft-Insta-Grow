# Sourced by the build scripts, which ship one payload under two file extensions.
# Run them from the repo root.
#
#   stage_pack <dir>       assembles the shared payload in build/<dir> and sets
#                          $staging to it.
#   pack_archive <name>    zips $staging into build/<name>.
#
# Only the jar carries loader metadata. The zip is published as a data pack version of
# its own, and Modrinth only runs a loader's file validator over versions that declare
# that loader, so a zip in a datapack-only version is never asked for a mod manifest.
. ./version.sh

stage_pack() {
	staging="build/$1"
	rm -rf "$staging"
	mkdir -p "$staging"
	cp pack.mcmeta LICENSE "$staging/"
	cp -R data "$staging/"
}

pack_archive() {
	archive="build/$1"
	rm -f "$archive"
	(cd "$staging" && zip -qr "../../$archive" .)
	echo "built $archive"
}
