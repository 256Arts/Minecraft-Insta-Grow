execute if predicate insta_grow:chance_15 run function insta_grow:grow/place {block:"minecraft:mangrove_propagule",feature:"minecraft:tall_mangrove"}
execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/try {block:"minecraft:mangrove_propagule",feature:"minecraft:mangrove",w:"3",s:"6",h:"12"}
