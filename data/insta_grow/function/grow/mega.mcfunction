# Macro args: block, feature. Tries the four 2x2 squares the clicked sapling can
# be part of, placing the mega tree from the north-west corner like vanilla does.
$execute positioned ~-1 ~ ~-1 run function insta_grow:grow/mega_try {block:"$(block)",feature:"$(feature)"}
$execute if score #done insta_grow.tmp matches 0 positioned ~ ~ ~-1 run function insta_grow:grow/mega_try {block:"$(block)",feature:"$(feature)"}
$execute if score #done insta_grow.tmp matches 0 positioned ~-1 ~ ~ run function insta_grow:grow/mega_try {block:"$(block)",feature:"$(feature)"}
$execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/mega_try {block:"$(block)",feature:"$(feature)"}
