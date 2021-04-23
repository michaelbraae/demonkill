extends PossessableAI

var SWIPE_SCENE = preload('res://Resources/Abilities/Swipe/Swipe.tscn')

func initialiseConfig():
	max_health = 3
	move_speed = 70
	attacks_in_sequence = 1
	repeat_attacks = true
	attack_range = 30
	attack_cooldown = 1
	complete_attack_sequence = true

func perAttackAction() -> void:
	var swipe_instance = SWIPE_SCENE.instance()
	add_child(swipe_instance)
	swipe_instance.target_actor = target_actor
	var angle = get_angle_to(target_actor.get_global_position())
	swipe_instance.bang(Vector2(cos(angle), sin(angle)), self)
