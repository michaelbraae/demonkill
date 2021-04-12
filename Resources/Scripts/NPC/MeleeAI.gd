extends PossessableAI

class_name MeleeAI

var SWIPE_SCENE = preload('res://Resources/Abilities/Swipe/Swipe.tscn')

func perAttackAction() -> void:
	var swipe_instance = SWIPE_SCENE.instance()
	add_child(swipe_instance)
	var angle = get_angle_to(target_actor.get_global_position())
	swipe_instance.bang(Vector2(cos(angle), sin(angle)), self)
