execute if predicate insta_grow:chance_50 run function insta_grow:grow/mega {block:"minecraft:spruce_sapling",feature:"minecraft:mega_spruce"}
execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/mega {block:"minecraft:spruce_sapling",feature:"minecraft:mega_pine"}
execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/place {block:"minecraft:spruce_sapling",feature:"minecraft:spruce"}
# Nothing fit anywhere: make room. A 2x2 still earns a mega tree, a lone one does not.
execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/mega_force {block:"minecraft:spruce_sapling",feature:"minecraft:mega_pine",w:"4",e:"5",s:"9",h:"30"}
execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/force {block:"minecraft:spruce_sapling",feature:"minecraft:spruce",w:"3",s:"6",h:"14"}
