extends CasterAI

func initialiseConfig() -> void:
	.initialiseConfig()
	attack_range = 350
	move_spped = 180

func setProjectileScene() -> void:
	PROJECTILE_SCENE = preload('res://resources/projectiles/energy_ball/energy_ball.tscn')
