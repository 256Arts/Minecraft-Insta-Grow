execute if block ~ ~ ~ #insta_grow:growable run return run function insta_grow:ray/hit
execute unless block ~ ~ ~ #insta_grow:ray_passable run return 0
scoreboard players remove @s insta_grow.ray 1
execute if score @s insta_grow.ray matches ..0 run return 0
execute positioned ^ ^ ^0.2 run function insta_grow:ray/step
