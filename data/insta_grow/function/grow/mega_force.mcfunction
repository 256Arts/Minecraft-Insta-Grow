# Macro args: block, feature, w, e, s, h. The same four 2x2 candidates grow/mega
# checks, but the corner that matches has its space cleared and given back instead of
# being given up on.
execute unless score #force insta_grow.config matches 1 run return 0
$execute positioned ~-1 ~ ~-1 if block ~ ~ ~ $(block) if block ~1 ~ ~ $(block) if block ~ ~ ~1 $(block) if block ~1 ~ ~1 $(block) run function insta_grow:grow/mega_force_place {block:"$(block)",feature:"$(feature)",w:"$(w)",e:"$(e)",s:"$(s)",h:"$(h)"}
$execute if score #done insta_grow.tmp matches 0 positioned ~ ~ ~-1 if block ~ ~ ~ $(block) if block ~1 ~ ~ $(block) if block ~ ~ ~1 $(block) if block ~1 ~ ~1 $(block) run function insta_grow:grow/mega_force_place {block:"$(block)",feature:"$(feature)",w:"$(w)",e:"$(e)",s:"$(s)",h:"$(h)"}
$execute if score #done insta_grow.tmp matches 0 positioned ~-1 ~ ~ if block ~ ~ ~ $(block) if block ~1 ~ ~ $(block) if block ~ ~ ~1 $(block) if block ~1 ~ ~1 $(block) run function insta_grow:grow/mega_force_place {block:"$(block)",feature:"$(feature)",w:"$(w)",e:"$(e)",s:"$(s)",h:"$(h)"}
$execute if score #done insta_grow.tmp matches 0 if block ~ ~ ~ $(block) if block ~1 ~ ~ $(block) if block ~ ~ ~1 $(block) if block ~1 ~ ~1 $(block) run function insta_grow:grow/mega_force_place {block:"$(block)",feature:"$(feature)",w:"$(w)",e:"$(e)",s:"$(s)",h:"$(h)"}
