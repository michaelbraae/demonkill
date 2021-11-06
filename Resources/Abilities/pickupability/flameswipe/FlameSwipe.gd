extends AbilityBase

var WHITE_IMPACT = preload('res://Resources/Effects/Impacts/WhiteImpact/WhiteImpact.tscn')

func initialiseConfig() -> void:
	distance_from_player = 15
	attack_move_speed = 10

func collisionEffect(target_actor) -> void:
	var impact_instance = WHITE_IMPACT.instance()
	get_tree().get_root().add_child(impact_instance)
	impact_instance.position = target_actor.get_global_position()
	impact_instance.play()
