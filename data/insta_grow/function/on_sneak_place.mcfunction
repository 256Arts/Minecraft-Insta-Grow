# Reward of insta_grow:sneak_placed_sapling — runs as the player, at the player.
# Revoke first so the criterion can fire again on the next click.
advancement revoke @s only insta_grow:sneak_placed_sapling
execute anchored eyes positioned ^ ^ ^ run function insta_grow:ray/start
