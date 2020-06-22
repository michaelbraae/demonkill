extends PathfindingAI

class_name PossessableAI

onready var bite_button = $BiteButton

func _ready():
	bite_button.hide()

func _process(delta):
	pass
#	if getState() == STUNNED:
#		bite_button.show()

# when possesed, the players inputs are applied to the possesed AI
 
