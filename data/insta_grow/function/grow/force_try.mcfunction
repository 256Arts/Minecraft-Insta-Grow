# Macro args: feature, w, e, s, h. Makes room for the tree without taking anything
# away. The box — w blocks west/north of here, e east/south, h tall — is copied into
# the insta_grow:scratch dimension, emptied, handed to the feature, and then every
# block that was in it is laid back down on top. Anything already standing in the
# tree's way therefore wins the overlap: the tree grows, the build is untouched, and
# the branches that wanted that space are the ones that lose. s is w + e, the box's
# span in scratch, passed in because functions cannot do arithmetic.
scoreboard players set #saved insta_grow.tmp 0
$execute store success score #saved insta_grow.tmp run clone ~-$(w) ~ ~-$(w) ~$(e) ~$(h) ~$(e) to insta_grow:scratch 0 0 0 replace force
# Nothing was copied, so there is nothing to put back: leave the world alone.
execute if score #saved insta_grow.tmp matches 0 run return 0
$fill ~-$(w) ~ ~-$(w) ~$(e) ~$(h) ~$(e) air replace
$execute store success score #done insta_grow.tmp run place feature $(feature) ~ ~ ~
$clone from insta_grow:scratch 0 0 0 $(s) $(h) $(s) ~-$(w) ~ ~-$(w) masked
