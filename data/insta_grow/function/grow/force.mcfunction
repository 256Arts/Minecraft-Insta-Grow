# Macro args: block, feature, w (box radius), s (w + w), h (box height). Last resort,
# only after a polite attempt has already failed: clear the space the tree needs,
# grow it, and put the cleared blocks straight back over it, so a tree that does not
# fit grows around what is in its way instead of through it. The 1x1 trunk shaft is
# tried first; the full box only if the canopy is blocked too, so a tree stopped by a
# single ceiling block is not clipped canopy-wide.
# `scoreboard players set #force insta_grow.config 0` turns it off.
execute unless score #force insta_grow.config matches 1 run return 0
setblock ~ ~ ~ air
$function insta_grow:grow/force_try {feature:"$(feature)",w:"0",e:"0",s:"0",h:"$(h)"}
$execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/force_try {feature:"$(feature)",w:"$(w)",e:"$(w)",s:"$(s)",h:"$(h)"}
$execute if score #done insta_grow.tmp matches 0 run setblock ~ ~ ~ $(block)
execute if score #done insta_grow.tmp matches 1 run function insta_grow:fx/grown
