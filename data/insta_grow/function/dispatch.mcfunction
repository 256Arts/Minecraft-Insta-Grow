scoreboard players set #done insta_grow.tmp 0
execute if block ~ ~ ~ minecraft:oak_sapling run function insta_grow:grow/oak
execute if block ~ ~ ~ minecraft:birch_sapling run function insta_grow:grow/try {block:"minecraft:birch_sapling",feature:"minecraft:birch",w:"2",s:"4",h:"9"}
execute if block ~ ~ ~ minecraft:acacia_sapling run function insta_grow:grow/try {block:"minecraft:acacia_sapling",feature:"minecraft:acacia",w:"4",s:"8",h:"10"}
execute if block ~ ~ ~ minecraft:cherry_sapling run function insta_grow:grow/try {block:"minecraft:cherry_sapling",feature:"minecraft:cherry",w:"4",s:"8",h:"12"}
execute if block ~ ~ ~ minecraft:azalea run function insta_grow:grow/try {block:"minecraft:azalea",feature:"minecraft:azalea_tree",w:"3",s:"6",h:"8"}
execute if block ~ ~ ~ minecraft:flowering_azalea run function insta_grow:grow/try {block:"minecraft:flowering_azalea",feature:"minecraft:azalea_tree",w:"3",s:"6",h:"8"}
execute if block ~ ~ ~ minecraft:mangrove_propagule[hanging=false] run function insta_grow:grow/mangrove
execute if block ~ ~ ~ minecraft:spruce_sapling run function insta_grow:grow/spruce
execute if block ~ ~ ~ minecraft:jungle_sapling run function insta_grow:grow/jungle
execute if block ~ ~ ~ minecraft:dark_oak_sapling run function insta_grow:grow/dark_oak
execute if block ~ ~ ~ minecraft:pale_oak_sapling run function insta_grow:grow/pale_oak
