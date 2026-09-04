# Macro args: block, feature.
setblock ~ ~ ~ air
setblock ~1 ~ ~ air
setblock ~ ~ ~1 air
setblock ~1 ~ ~1 air
$execute store success score #done insta_grow.tmp run place feature $(feature) ~ ~ ~
$execute if score #done insta_grow.tmp matches 0 run setblock ~ ~ ~ $(block)
$execute if score #done insta_grow.tmp matches 0 run setblock ~1 ~ ~ $(block)
$execute if score #done insta_grow.tmp matches 0 run setblock ~ ~ ~1 $(block)
$execute if score #done insta_grow.tmp matches 0 run setblock ~1 ~ ~1 $(block)
execute if score #done insta_grow.tmp matches 1 run function insta_grow:fx/grown
