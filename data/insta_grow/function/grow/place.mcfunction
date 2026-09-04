# Macro args: block, feature. Clears the sapling first so the tree has room,
# and puts it back if the feature had nowhere to generate.
setblock ~ ~ ~ air
$execute store success score #done insta_grow.tmp run place feature $(feature) ~ ~ ~
$execute if score #done insta_grow.tmp matches 0 run setblock ~ ~ ~ $(block)
execute if score #done insta_grow.tmp matches 1 run function insta_grow:fx/grown
