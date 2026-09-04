# Insta Grow

A Minecraft Java data pack that turns a sapling into a full tree instantly. Two
ways to ask for it:

- **Bone meal a sapling** — one application, one tree, every time. No repeated
  clicking waiting for it to take.
- **Sneak while you place a sapling** — it grows the moment it lands.

Placing a sapling normally does nothing unusual, so ordinary planting, tree
farms and sapling storage all behave exactly as they do in vanilla.

## What grows

| Sapling | Result |
| --- | --- |
| Oak | Oak, 10% chance of a big oak |
| Birch, Acacia, Cherry | Their normal tree |
| Azalea / Flowering azalea | Azalea tree |
| Mangrove propagule | Mangrove, 15% chance of the tall one |
| Spruce | Spruce; a 2x2 grows a mega spruce or pine |
| Jungle | Jungle tree; a 2x2 grows a mega jungle tree |
| Dark oak, Pale oak | 2x2 only, same as vanilla |

For the 2x2 trees, plant all four saplings normally and bone meal any one of
them.

## Growing where it does not fit

If the tree has nowhere to grow, the pack makes room for it and then hands the
room straight back: the space is copied aside, emptied, given to the tree, and
every block that was in it is laid back down on top of the tree. **Nothing you
have built is replaced, broken or dropped** — a tree grown under a floor keeps
the floor, and the trunk and branches that wanted that space are the ones that
lose it.

So a tree always grows, but a tree grown into a wall comes out clipped by that
wall. That is the trade: the build wins every overlap.

It stays as tidy as it can. The tree is only forced after the ordinary attempt
has failed, the narrow trunk shaft is cleared first and the full canopy box only
if that was not enough, and the smallest tree in the running is the one forced —
a cramped oak grows as a plain oak, never as the big one.

To turn it off, so a blocked sapling is simply left standing like a wasted bone
meal:

```mcfunction
scoreboard players set #force insta_grow.config 0
```

Set it back to `1` to turn it on again. The setting is per world and survives
`/reload`.

Growth can still fail on ground the tree refuses — a mangrove away from mud,
say.

Bone meal is still consumed, and it still does nothing on a dark oak or pale oak
sapling that is not part of a 2x2.

## Install

Pick whichever suits your setup — all three ship the same files and behave
identically.

The pack adds one dimension, `insta_grow:scratch` — an empty void with a single
force-loaded chunk, used as scratch space while a tree is grown. Nothing lives
there and nothing generates there. Removing the pack from a world it has run in
leaves that dimension's (empty) region files behind, which is harmless.

### As a data pack

1. Download the zip from the [latest release](../../releases/latest), or clone
   this repo and run `./build-datapack-zip.sh` to produce
   `build/insta-grow-datapack-<version>.zip`.
2. Drop the zip (or the folder containing `pack.mcmeta`) into
   `<your world>/datapacks/`.
3. In game, run `/reload`, or restart the world.

### As a Fabric or NeoForge mod

1. Download the jar from the [latest release](../../releases/latest), or run
   `./build-mod-jar.sh` to produce `build/insta-grow-<version>.jar`.
2. Put it in your `mods/` folder, client or server.

One jar covers both loaders: each ignores the other's metadata file, so it
carries `fabric.mod.json` and `META-INF/neoforge.mods.toml` side by side. Needs
Fabric Loader 0.15 or newer, or NeoForge for 1.21.4 or newer. Fabric API is not
required, and neither is a compiler — both loaders read the `data/` directory of
any mod jar as a data pack, and NeoForge's `lowcodefml` language loader exists
precisely so a mod can ship without a Java entrypoint. There is no Java in it.

The mod applies to every world at once instead of per world, and its data pack
is always on, so `/datapack disable` cannot turn it off — remove the jar
instead. Because the loaders generate a mod jar's pack metadata themselves, the
version floor comes from `depends.minecraft` in `fabric/fabric.mod.json` and the
`versionRange`s in `neoforge/neoforge.mods.toml` rather than from `pack.mcmeta`;
keep them in step.

Requires **Minecraft Java 1.21.4 or newer**, up to 26.2.

`pack.mcmeta` declares the range three times on purpose. `pack_format` is the
1.21.4 number, `supported_formats` is the span the versions between want, and
`min_format` / `max_format` are what 1.21.9 and later read. All three are
required together: a pack whose `pack_format` is 81 or lower is rejected without
`supported_formats`, and `supported_formats`' upper bound has to agree with
`max_format`, or the metadata fails to parse and the pack falls back to being
treated as a 1.6-era pack. Raise `max_format` and the `max_inclusive` beside it
together as new versions land — 26.2 is data pack format 107.1.

## How it works

Two advancements listen for `minecraft:item_used_on_block` — one for bone meal
used on a sapling, one for a sapling placed while sneaking — so the pack does no
per-tick work at all. Each reward function revokes its advancement (so it can
fire again) and raycasts ~5 blocks along the crosshair to find the sapling. The
tree itself comes from `/place feature`, the same worldgen features vanilla
saplings use, and when that reports it had nowhere to generate, the space it
needs is cloned into the pack's own `insta_grow:scratch` dimension, emptied,
offered to the feature again, and cloned back `masked`, which restores every
block that was there over the top of the new tree.

## Releasing

Both artifacts and all three distribution channels come from one GitHub release.

1. Bump `version` in `fabric/fabric.mod.json`, and `depends.minecraft`, the
   `neoforge/neoforge.mods.toml` version ranges and the `pack.mcmeta` format
   numbers if the supported range moved.
2. Publish a GitHub release tagged `v<that version>`. Its body becomes the
   changelog everywhere.

`.github/workflows/publish.yml` then checks the tag against
`fabric/fabric.mod.json`, builds the zip and the jar, and hands both
to [mc-publish](https://github.com/Kira-NT/mc-publish), which attaches them to
the release and uploads them to Modrinth and CurseForge.

The two mod sites are opt-in — mc-publish skips any platform whose token is
missing, so the release still happens with none of them configured. To turn one
on, add its repository variable and secret under **Settings → Secrets and
variables → Actions**:

| Platform | Variable | Secret |
| --- | --- | --- |
| Modrinth | `MODRINTH_ID` (project id or slug) | `MODRINTH_TOKEN` |
| CurseForge | `CURSEFORGE_ID` (numeric project id) | `CURSEFORGE_TOKEN` |

The Modrinth token is a personal access token, and it needs four scopes: **Read
projects**, **Create versions**, **Read versions** and **Write versions**. The
two version-reading and version-writing ones are there only so mc-publish can
unfeature the versions this one supersedes — add `modrinth-unfeature-mode: none`
to the workflow and **Read projects** plus **Create versions** is the whole
list. No project-write, no delete, no user scopes. The account the token belongs
to also has to be a member of the project with permission to upload.

The zip and the jar go up as two versions, not one. A Modrinth version installs
its primary file, so a jar riding along in a data pack version is a download
nothing can install; the data pack becomes version `<version>+datapack` with the
`datapack` loader and the mod becomes `<version>+mod` with `fabric` and
`neoforge`. Both declare a game version range of `>=1.21.4 <=26.2`, a third copy
of the ceiling in `pack.mcmeta` — raise `game-versions` in the workflow whenever
you raise `max_format` and `max_inclusive`.

Fabric and NeoForge share one jar rather than shipping two because Modrinth runs
every validator whose loader the version declares over every file in it with a
matching extension, so a Fabric-only jar in a version that also declares
`neoforge` is rejected. The zip needs no mod manifest for the same reason in
reverse: its version declares `datapack` and nothing else.

## License

CC0 1.0 Universal — public domain dedication. See [LICENSE](LICENSE). Copy it,
ship it, sell it, no attribution needed.
