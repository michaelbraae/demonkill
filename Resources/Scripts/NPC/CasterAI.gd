extends AttackerAI

class_name CasterAI

var PROJECTILE_SCENE
var all_projectiles_fired = 0

func initialiseConfig() -> void:
	setProjectileScene()

func setProjectileScene() -> void:
	pass

func setAllProjectilesFired(a_p_f : bool) -> void:
	all_projectiles_fired = a_p_f

func getAllProjectilesFired() -> bool:
	return all_projectiles_fired

func perAttackAction() -> void:
	if not getHasAttackLanded():
		setAttackStarted(true)
		setHasAttackLanded(true)
		var projectile_instance = PROJECTILE_SCENE.instance()
		get_parent().get_parent().add_child(projectile_instance)
		projectile_instance.setTargetId("IS_PLAYER")
		projectile_instance.setMoveSpeed(5)
		projectile_instance.set_global_position(get_global_position())
		projectile_instance.setTargetVector(
			player.get_global_position() - get_global_position()
		)
