extends Node

class_name Weapon

export(int, "SWORD", "AXES", "SPEAR", "BOW", "PISTOL", "SHOTGUN", "WAND") var archetype

export(int, "STRENGTH", "INTELLIGENCE", "SURVIVAL") var affinity



# weapon affinity

# effects should have damage frames

# attack effect

# animatedSprite - for looping through environmental effects (fire)
# for v1 a Sprite is fine

# how can this be tied to the player's animation
# by generalising the player's animation names for the weapons aswell, we can set the same animation
# for both player and weapon, ie: attack_right. exporting only the layers of the weapon we want to use

# we can then quickly produce new weapons by copying the animation frames to a new weapon directory and filling in the frames.
