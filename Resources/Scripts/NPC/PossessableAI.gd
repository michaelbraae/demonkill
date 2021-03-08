extends CombatReadyAI

class_name PossessableAI

onready var bite_button = $BiteButton

func _ready():
	bite_button.hide()

func _process(delta):
	if getState() == STUNNED:
		bite_button.show()
	else:
		bite_button.hide()

func runDecisionTree() -> void:
	if getState() == POSSESSED:
		pass
	else:
		.runDecisionTree()

func handlePostAnimState() -> void:
	if getState() == POSSESSED:
		pass
	else:
		.handlePostAnimState()
# when possesed, the players inputs are applied to the possesed AI
 
