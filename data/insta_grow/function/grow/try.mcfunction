# Macro args: block, feature, w, s, h. The whole story for a one-sapling tree: place
# it if it fits, and if it does not, clear the room it needs and hand the cleared
# blocks back afterwards.
$function insta_grow:grow/place {block:"$(block)",feature:"$(feature)"}
$execute if score #done insta_grow.tmp matches 0 run function insta_grow:grow/force {block:"$(block)",feature:"$(feature)",w:"$(w)",s:"$(s)",h:"$(h)"}
