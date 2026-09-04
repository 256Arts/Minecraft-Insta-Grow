# Run as a player, anchored to the eyes. 26 steps of 0.2 covers the 5 block
# creative interaction range, which is as far as the sapling can have gone.
scoreboard players set @s insta_grow.ray 26
function insta_grow:ray/step
