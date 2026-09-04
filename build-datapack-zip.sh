#!/bin/sh
# Packages the data pack as a plain zip, the form Minecraft and the mod sites expect.
# Drop the zip straight into <world>/datapacks/ — no need to unpack it.
set -eu

. ./pack-lib.sh

stage_pack datapack
pack_archive "insta-grow-datapack-$version.zip"
