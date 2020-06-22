extends PlayerAttack

class_name PlayerPossession

var possessedNPC

func setPossessedNPC(possessed_NPC : KinematicBody2D) -> void:
	possessedNPC = possessed_NPC

func getPossessedNPC() -> KinematicBody2D:
	return possessedNPC
# handles logic around possession

# Several factors should go into the players ability to possess an npc

# If hostile, the NPC must be stunned
# the npc must be mature, ie: not a child  
# if not hostile, bites can be made at any time?
# 
