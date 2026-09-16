# Vanilla rolls the leaf colour when the sapling grows, so the colour is rolled here
# too — 1-in-3, then 1-in-2 of what is left, is an even split across the three. It is
# picked before anything is placed and carried through the forced attempt as well, so
# a cramped spot does not always come out the same colour. The fall-through only
# reaches the next colour when forcing is turned off, and then it is a fresh chance
# rather than the same tree twice: /place re-rolls the trunk height every call.
execute if predicate insta_grow:chance_33 run function insta_grow:grow/try {block:"minecraft:poplar_sapling",feature:"minecraft:red_poplar",w:"6",s:"12",h:"20"}
execute if score #done insta_grow.tmp matches 0 if predicate insta_grow:chance_50 run function insta_grow:grow/try {block:"minecraft:poplar_sapling",feature:"minecraft:orange_poplar",w:"6",s:"12",h:"20"}
execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/try {block:"minecraft:poplar_sapling",feature:"minecraft:yellow_poplar",w:"6",s:"12",h:"20"}
