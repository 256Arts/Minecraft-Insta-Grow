# 2x2 only. pale_oak_bonemeal is the creaking-heart-free variant saplings use;
# fall back to the worldgen feature id in case the pack runs on an older build.
function insta_grow:grow/mega {block:"minecraft:pale_oak_sapling",feature:"minecraft:pale_oak_bonemeal"}
execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/mega {block:"minecraft:pale_oak_sapling",feature:"minecraft:pale_oak"}
execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/mega_force {block:"minecraft:pale_oak_sapling",feature:"minecraft:pale_oak_bonemeal",w:"4",e:"5",s:"9",h:"18"}
execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/mega_force {block:"minecraft:pale_oak_sapling",feature:"minecraft:pale_oak",w:"4",e:"5",s:"9",h:"18"}
