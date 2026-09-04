# Macro args: block, feature. Run at a candidate north-west corner.
$execute if block ~ ~ ~ $(block) if block ~1 ~ ~ $(block) if block ~ ~ ~1 $(block) if block ~1 ~ ~1 $(block) run function insta_grow:grow/mega_place {block:"$(block)",feature:"$(feature)"}
