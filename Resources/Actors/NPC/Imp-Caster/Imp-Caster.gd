extends CasterAI

func initialiseConfig() -> void:
	.initialiseConfig()
	attack_range = 350
	move_speed = 180
	attacks_in_sequence = 5
	repeat_attacks = true
	attack_cooldown = 2
	complete_attack_sequence = true

func setProjectileScene() -> void:
	PROJECTILE_SCENE = preload('res://Resources/Abilities/Projectiles/energy-ball/Energy-Ball.tscn')
