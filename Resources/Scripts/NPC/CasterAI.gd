extends CombatReadyAI

class_name CasterAI

var PROJECTILE_SCENE

func initialiseConfig() -> void:
	setProjectileScene()

func setProjectileScene() -> void:
	pass

func perAttackAction() -> void:
	if not has_attack_landed:
		attack_started = true
		has_attack_landed = true
		var projectile_instance = PROJECTILE_SCENE.instance()
		get_parent().get_parent().add_child(projectile_instance)
		projectile_instance.target_id = "IS_PLAYER"
		projectile_instance.move_speed = 5
		projectile_instance.set_global_position(get_global_position())
		projectile_instance.target_vector = target_actor.get_global_position() - get_global_position()
