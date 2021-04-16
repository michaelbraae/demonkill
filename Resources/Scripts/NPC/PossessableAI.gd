extends CombatReadyAI

class_name PossessableAI

onready var bite_button = $BiteButton
onready var bite_box = $EnemyBiteBox

func _ready():
	bite_button.hide()

func _process(_delta):
	if isPossessed():
		if Input.is_action_just_pressed('bite'):
			PossessionState.initiateBite(self)
		bite_button.hide()
	elif state == STUNNED:
		bite_button.show()
	else:
		bite_button.hide()
