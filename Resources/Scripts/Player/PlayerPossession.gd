extends PlayerAttack

class_name PlayerPossession

onready var bite_box = $BiteBox

func _process(_delta):
	if Input.is_action_just_pressed("bite"):
		PossessionState.possessNewEntity(bite_box, self)
