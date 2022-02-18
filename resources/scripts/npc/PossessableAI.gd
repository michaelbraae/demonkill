extends CombatReadyAI

class_name PossessableAI

onready var bite_box = $EnemyBiteBox

func _process(_delta):
	if isPossessed():
		if Input.is_action_just_pressed('bite'):
			PossessionState.initiateBite(self)
