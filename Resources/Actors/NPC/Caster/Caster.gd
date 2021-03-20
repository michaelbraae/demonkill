extends CasterAI

func initialiseConfig() -> void:
	.initialiseConfig()
	attack_range = 350
	move_spped = 180
	attacks_in_sequence = 5
	repeat_attacks = true
	complete_attack_sequence = true

func setProjectileScene() -> void:
	PROJECTILE_SCENE = preload('res://Resources/Projectiles/Energy-Ball/Energy-Ball.tscn')
