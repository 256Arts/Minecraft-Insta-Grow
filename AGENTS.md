# Insta Grow — data pack

Minecraft Java 26.3 data pack. Namespace `insta_grow`. Repo root is the pack root.
`pack.mcmeta` carries `min_format` / `max_format` only (floats, 26.3 = 121.0);
`pack_format` and `supported_formats` are the pre-1.21.9 spelling and are deliberately
absent, because they are only required below format 82. 26.3 rewrote the
loot-condition and advancement schemas — `type` instead of `condition`, and a single
condition object where a list used to go — so the pack cannot support 26.2 and 26.3
from one set of files. Overlays cannot bridge it either: an overlay entry needs
`formats` below format 82 and is rejected for carrying it at 82 and above.
That is why `min_format` sits on 26.3 as well: **backwards compatibility is worth no
extra work.** Widen the range for free when a version bump changes no files, but the
moment one has to be edited, move `min_format` up and drop the old versions rather than
maintaining two shapes — every previously shipped release stays downloadable from
Modrinth, CurseForge and GitHub releases, so players on an older Minecraft just install
the older file.
No tick function — detection is advancement-driven.

Both advancements use `item_used_on_block` and share the same reward shape: revoke
self (required to re-arm the criterion), then raycast.

- `advancement/used_bone_meal` — tool `minecraft:bone_meal`, clicked block in
  `#insta_grow:growable`. Reward `function/on_bone_meal`.
- `advancement/sneak_placed_sapling` — tool in `#insta_grow:saplings`, player
  sneaking. Reward `function/on_sneak_place`.
- `function/ray/*` — 26 x 0.2 block ray from the eyes; first block in
  `#insta_grow:growable` wins, stops at anything not in `#insta_grow:ray_passable`.
- `function/dispatch` — sapling block id -> `grow/*`. A literal block id that does not
  exist on the running version stops the whole function from loading, so this file is
  the one place a version bump can break silently at load time.
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
  12 (`grow/poplar`), so it stays inside chunk 0 0.
- `function/grow/try` — args `block`, `feature`, `w`, `s`, `h`: `place`, then
  `force`. The whole chain for a one-sapling tree, called straight from `dispatch`.

Feature ids are passed as macro strings, so a name that does not exist on the running
version fails silently instead of breaking function loading. Sapling ids reached
through a macro (`$(block)`, for the restore) are safe for the same reason — only a
literal id in a non-macro command is a load-time hazard.

`grow/poplar` rolls the leaf colour up front (`chance_33`, then `chance_50` on the
remainder) and hands the chosen one to `grow/try`, so the forced attempt keeps that
colour rather than always landing on the last branch. The `w:6`/`s:12` box is the
widest the scratch dimension can take — `load` force-loads chunk 0 0 only, so `s`
cannot exceed 15 — and it covers the common canopy radii; the rare radius-7/8 roll
just fails to place and is restored, as any tree that still does not fit is.

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
no Java entrypoint. **Fabric API is required** — Fabric Loader 0.19.5 ships no
mod-resource-pack code at all, so without `fabric-resource-loader-v0` the mod loads and
its `data/` is ignored in total silence. Hence the `fabric-resource-loader-v0`
dependency in `fabric/fabric.mod.json`; it turns that into a refusal to launch.
NeoForge needs no equivalent. Bump the version in `fabric/fabric.mod.json`; bump the
supported range in `depends.minecraft`, `neoforge/neoforge.mods.toml` (both
`versionRange`s) and `pack.mcmeta` together.

`.github/workflows/publish.yml` runs on a `v*` tag push, which `release.sh` (the
`Release` Conductor run script) makes: it tags `origin/main` with the
`fabric.mod.json` version, refusing one already tagged, and watches the run. The
workflow fails if the tag is not `v<fabric.mod.json version>`, builds both artifacts, and runs
`Kira-NT/mc-publish` three times: the zip as Modrinth version `<version>+datapack`
(loader `datapack`), the jar as Modrinth/CurseForge version `<version>+mod` (loaders
`fabric`, `neoforge`), and both files onto the GitHub release. The mod is a separate
version because a Modrinth version installs its primary file only — a jar attached to a
data pack version is a supplementary download nothing can install — and a project cannot
hold two versions with the same number, hence the semver build suffixes. The GitHub
release is its own last step, with generated notes, so neither site step names it.
`loaders`, `game-versions` (`26.3`, a third copy of the version in `pack.mcmeta` —
bump it with the others) and `environment` (`both` — a single flag
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
