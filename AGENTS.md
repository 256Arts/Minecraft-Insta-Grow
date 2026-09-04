# Insta Grow — data pack

Minecraft Java 1.21.4 - 26.2 data pack. Namespace `insta_grow`. Repo root is the pack
root. `pack.mcmeta` carries all three of `pack_format` (pre-1.21.9),
`supported_formats` and `min_format` / `max_format` (1.21.9+, floats, 26.2 = 107.1).
All three are needed: a `pack_format` of 81 or lower without `supported_formats` is
rejected, and `supported_formats`' `max_inclusive` must match `max_format`'s major
version or the metadata does not parse at all.
No tick function — detection is advancement-driven.

Both advancements use `item_used_on_block` and share the same reward shape: revoke
self (required to re-arm the criterion), then raycast.

- `advancement/used_bone_meal` — tool `minecraft:bone_meal`, clicked block in
  `#insta_grow:growable`. Reward `function/on_bone_meal`.
- `advancement/sneak_placed_sapling` — tool in `#insta_grow:saplings`, player
  sneaking. Reward `function/on_sneak_place`.
- `function/ray/*` — 26 x 0.2 block ray from the eyes; first block in
  `#insta_grow:growable` wins, stops at anything not in `#insta_grow:ray_passable`.
- `function/dispatch` — sapling block id -> `grow/*`.
- `function/grow/place` and `grow/mega*` — macro functions; args `block` + `feature`.
  They clear the sapling, `place feature`, and restore it if placement failed.
  `#done insta_grow.tmp` is the "a tree was placed" flag; `dispatch` resets it.
- `function/grow/force`, `grow/mega_force*` and `grow/force_try` — the last resort
  once every polite attempt left `#done` at 0. `force_try` never destroys anything:
  it clones the box into `insta_grow:scratch`, `fill`s it with air (plain `replace`,
  no `destroy`, so nothing drops), places the feature, then clones the copy back
  `masked`, which lays every block that was there back over the new tree. The build
  therefore wins every overlap and the tree comes out clipped. Box args `w`/`e`/`h`
  plus `s` (= `w` + `e`, the span of the copy in scratch) are macro strings because
  functions cannot do arithmetic; `#saved insta_grow.tmp` guards on the clone
  succeeding, so a failed copy leaves the world untouched instead of digging a hole.
  The 1x1 or 2x2 trunk shaft is tried first and the full box only if that still
  failed. The box starts at the sapling's own y, never below it. Gated on
  `#force insta_grow.config`, which `load` defaults to 1 without clobbering a world
  that set it to 0. Only the smallest feature in a chain is ever forced.
- `dimension/scratch` + `dimension_type/scratch` — a void flat dimension, y 0..47,
  scratch space for the clone above. `load` runs `forceload add 0 0` in it so the
  clone always has a loaded target; the box is anchored at 0 0 0 and `s` maxes out at
  9, so it stays inside chunk 0 0.
- `function/grow/try` — args `block`, `feature`, `w`, `s`, `h`: `place`, then
  `force`. The whole chain for a one-sapling tree, called straight from `dispatch`.

Feature ids are passed as macro strings, so a name that does not exist on the
running version fails silently instead of breaking function loading.

A plain right-click on a planted sapling is not detectable today, hence the bone meal
and sneak-place triggers. README has a test for whether `any_block_use` has changed
that; if it has, it replaces `sneak_placed_sapling` and reuses the same raycast.

Two build scripts, one payload, two file extensions. Both source `pack-lib.sh`, which
sources `version.sh` (the one version number lives in `fabric/fabric.mod.json`) and
exposes `stage_pack <dir>` plus `pack_archive <name>` (zip it). Run them from the repo
root.

- `build-datapack-zip.sh` — `insta-grow-datapack-<version>.zip`.
- `build-mod-jar.sh` — `insta-grow-<version>.jar`, for Fabric and NeoForge both.

`install-in-modrinth.sh [profile]` builds the jar and drops it into a local Modrinth
App profile's `mods/` (default `Latest Fabric`), clearing older `insta-grow-*.jar`
copies first. macOS only; it is the `Install in Modrinth` Conductor run script in
`.conductor/settings.toml`.

`stage_pack` puts `pack.mcmeta`, `LICENSE` and `data/` into both; `build-mod-jar.sh`
adds `fabric/fabric.mod.json` and `neoforge/neoforge.mods.toml` (`@VERSION@` `sed`ded,
written to `META-INF/neoforge.mods.toml`) on top, so only the jar carries loader
metadata. One jar serves both loaders: Modrinth runs every validator whose loader the
version declares and whose file extension matches over *every* file in that version, so
a Fabric-only jar in a version that also declares `neoforge` is rejected. The zip stays
bare because it ships as its own datapack-only version, which no mod validator looks
at. The manifests are inert where they are not read — each loader ignores the other's.

No Java, no Gradle, no Loom, no compiler: both loaders treat a mod jar's `data/` as an
always-on data pack, and NeoForge's `lowcodefml` language loader is made for mods with
no Java entrypoint. Bump the version in `fabric/fabric.mod.json`; bump the supported
range in `depends.minecraft`, `neoforge/neoforge.mods.toml` (both `versionRange`s) and
`pack.mcmeta` together.

`.github/workflows/publish.yml` runs on `release: published`. It fails the release if
the tag is not `v<fabric.mod.json version>`, builds both artifacts, and runs
`Kira-NT/mc-publish` three times: the zip as Modrinth version `<version>+datapack`
(loader `datapack`), the jar as Modrinth/CurseForge version `<version>+mod` (loaders
`fabric`, `neoforge`), and both files onto the GitHub release. The mod is a separate
version because a Modrinth version installs its primary file only — a jar attached to a
data pack version is a supplementary download nothing can install — and a project cannot
hold two versions with the same number, hence the semver build suffixes. The GitHub
upload is its own step so neither site step renames the release to its version name.
`loaders`, `game-versions` (`>=1.21.4 <=26.2`, a fourth copy of the range in
`pack.mcmeta` — bump it with the others) and `environment` (`both` — a single flag
value, not a list, or the run dies on `Cannot convert "environment" to
"LoaderEnvironmentType"`) are all explicit rather than inferred: mc-publish reads
metadata from one file only, and half of what ships here is a bare zip. Modrinth and
CurseForge come from `vars.MODRINTH_ID` / `vars.CURSEFORGE_ID` plus the matching
secrets; mc-publish skips a platform whose token is unset, so an unconfigured repo
still publishes to the GitHub release.

The data pack step is Modrinth-only on purpose. mc-publish appends CurseForge's
Client/Server ids from the environment group only when it also resolved at least one
mod loader id (`loaderIds.length ? gameVersionIds.concat(loaderIds, environmentIds,
javaIds) : gameVersionIds` in `curseforge-upload-api-client.ts`), `datapack` is not a
CurseForge loader, and only the first id variant is ever attempted — so sending the zip
to CurseForge fails the whole workflow with `errorCode 1021, "You must select at least
one version from the environment group of versions"` before Modrinth or the GitHub
upload run. The jar declares `fabric` and `neoforge`, so it resolves loaders and carries
the environment ids fine; CurseForge users install the jar.
