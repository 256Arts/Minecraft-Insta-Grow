# Reward of insta_grow:used_bone_meal — the clicked block was a sapling, but vanilla
# bone meal may already have grown it on this same click, in which case the ray finds
# nothing and this does nothing.
advancement revoke @s only insta_grow:used_bone_meal
execute anchored eyes positioned ^ ^ ^ run function insta_grow:ray/start
