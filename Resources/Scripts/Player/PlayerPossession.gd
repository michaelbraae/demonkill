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
	GameState.state = GameState.CONTROLLING_NPC
	npc.npc_camera.make_current()
	npc.bite_button.hide()
	PossessionState.possessedNPC = npc
	self.queue_free()

func _process(delta):
	if Input.is_action_just_pressed("bite"):
		bite()

func handlePlayerAction() -> void:
	if GameState.state == GameState.CONTROLLING_PLAYER:
		.handlePlayerAction()
	#elif GameState.
	#if getState() == POSSESSING:
	#	setVelocity()
	#	getPossessedNPC().setVelocity(velocity)
	#else:
	#	.handlePlayerAction()
