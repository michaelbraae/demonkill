extends PlayerAttack

class_name PlayerPossession

var possessedNPC
onready var bite_box = $BiteBox

func setPossessedNPC(possessed_NPC : KinematicBody2D) -> void:
	possessedNPC = possessed_NPC

func getPossessedNPC() -> KinematicBody2D:
	return possessedNPC

func bite() -> void:
	var areas = bite_box.get_overlapping_areas()
	if areas:
		for area in areas:
			if area.get_name() == "BiteBox":
				var parent = area.get_parent()
				if parent.getState() == parent.STUNNED:
					parent.setState(parent.POSSESSED)
					setPossessedNPC(area.get_parent())

func _process(delta):
	if Input.is_action_just_pressed("bite"):
		bite()
# handles logic around possession

# Several factors should go into the players ability to possess an npc

# If hostile, the NPC must be stunned
# the npc must be mature, ie: not a child  
# if not hostile, bites can be made at any time?
# 
