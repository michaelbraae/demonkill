extends AbilityBase

var WHITE_IMPACT = preload('res://resources/effects/impacts/white_impact/WhiteImpact.tscn')

func initialiseConfig() -> void:
	damage = 5
	distance_from_player = 15
	attack_move_speed = 10

func collisionEffect(target_actor) -> void:
	var impact_instance = WHITE_IMPACT.instance()
	get_tree().get_root().add_child(impact_instance)
	impact_instance.position = target_actor.get_global_position()
	impact_instance.play()
