# Dark oaks only grow from a 2x2, same as vanilla — no single-sapling fallback, and
# no room to clear for one either.
function insta_grow:grow/mega {block:"minecraft:dark_oak_sapling",feature:"minecraft:dark_oak"}
execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/mega_force {block:"minecraft:dark_oak_sapling",feature:"minecraft:dark_oak",w:"3",e:"4",s:"7",h:"14"}
