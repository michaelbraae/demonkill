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
					possess(parent)

func possess(npc) -> void:
	setState(POSSESSING)
	removeWeapon()
	animatedSprite.hide()
	npc.setState(npc.POSSESSED)
	npc.npc_camera.make_current()
	setPossessedNPC(npc)

func _process(delta):
	if Input.is_action_just_pressed("bite"):
		if getState() == POSSESSING:
			var npc = getPossessedNPC()
			setPossessedNPC(null)
			setState(IDLE)
			camera2D.make_current()
			animatedSprite.show()
			readyWeaponInstance()
			npc.queue_free()
		else:
			bite()

func handlePlayerAction() -> void:
	if getState() == POSSESSING:
		setVelocity()
		getPossessedNPC().setVelocity(velocity)
	else:
		.handlePlayerAction()

#func _physics_process(_delta : float):
#	if getState() == POSSESSING:
#		getPossessedNPC().move_and_slide(velocity)
#		pass
#	else:
#	._physics_process(_delta)
## handles logic around possession

# Several factors should go into the players ability to possess an npc

# If hostile, the NPC must be stunned
# the npc must be mature, ie: not a child  
# if not hostile, bites can be made at any time?
# 
