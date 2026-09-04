function insta_grow:grow/mega {block:"minecraft:jungle_sapling",feature:"minecraft:mega_jungle_tree"}
execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/place {block:"minecraft:jungle_sapling",feature:"minecraft:jungle_tree_no_vine"}
execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/mega_force {block:"minecraft:jungle_sapling",feature:"minecraft:mega_jungle_tree",w:"4",e:"5",s:"9",h:"22"}
execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/force {block:"minecraft:jungle_sapling",feature:"minecraft:jungle_tree_no_vine",w:"3",s:"6",h:"16"}
