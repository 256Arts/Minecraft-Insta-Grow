# #done insta_grow.tmp = "a tree was placed"; #saved insta_grow.tmp = "the box was
# copied to scratch"; insta_grow.ray = raycast step counter.
scoreboard objectives add insta_grow.tmp dummy
scoreboard objectives add insta_grow.ray dummy
# #force insta_grow.config = "clear room for a tree that does not fit, then put what
# was cleared back on top of it". On unless a world turns it off, and left alone once
# set, so the choice survives a /reload.
scoreboard objectives add insta_grow.config dummy
execute unless score #force insta_grow.config matches -2147483648..2147483647 run scoreboard players set #force insta_grow.config 1
# insta_grow:scratch holds the copy while the tree is grown in its place. The clone
# needs the chunk loaded, and forceload is stored per world, so this is a no-op after
# the first run.
execute in insta_grow:scratch run forceload add 0 0
