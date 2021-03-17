extends CombatReadyAI

class_name PossessableAI

onready var bite_button = $BiteButton
onready var npc_camera = $Camera2D

func _ready():
	bite_button.hide()

func _process(delta):
	if isPossessed():
		bite_button.hide()
	elif getState() == STUNNED:
		bite_button.show()
	else:
		bite_button.hide()

func handlePostAnimState() -> void:
	.handlePostAnimState()
# when possesed, the players inputs are applied to the possesed AI
 
