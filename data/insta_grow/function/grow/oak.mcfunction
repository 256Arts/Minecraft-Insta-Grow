# 1-in-10 chance of the big oak, matching vanilla sapling growth. Only the plain oak
# is ever forced, so a cramped spot is not cleared to fancy oak size.
execute if predicate insta_grow:chance_10 run function insta_grow:grow/place {block:"minecraft:oak_sapling",feature:"minecraft:fancy_oak"}
execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/try {block:"minecraft:oak_sapling",feature:"minecraft:oak",w:"2",s:"4",h:"8"}
