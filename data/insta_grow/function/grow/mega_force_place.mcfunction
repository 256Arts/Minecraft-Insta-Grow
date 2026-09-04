# Macro args: block, feature, w, e, s, h. Run at the north-west corner. Clears the
# four saplings, then makes room the same way grow/force does: the 2x2 trunk shaft
# first, the full box only if that was not enough. e is one larger than w because the
# box is measured from that corner, and s is w + e.
setblock ~ ~ ~ air
setblock ~1 ~ ~ air
setblock ~ ~ ~1 air
setblock ~1 ~ ~1 air
$function insta_grow:grow/force_try {feature:"$(feature)",w:"0",e:"1",s:"1",h:"$(h)"}
$execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/force_try {feature:"$(feature)",w:"$(w)",e:"$(e)",s:"$(s)",h:"$(h)"}
$execute if score #done insta_grow.tmp matches 0 run setblock ~ ~ ~ $(block)
$execute if score #done insta_grow.tmp matches 0 run setblock ~1 ~ ~ $(block)
$execute if score #done insta_grow.tmp matches 0 run setblock ~ ~ ~1 $(block)
$execute if score #done insta_grow.tmp matches 0 run setblock ~1 ~ ~1 $(block)
execute if score #done insta_grow.tmp matches 1 run function insta_grow:fx/grown
