extends CasterAI

func initialiseConfig() -> void:
	.initialiseConfig()
	attacks_in_sequence = 1
	attack_range = 250
	attack_cooldown = 2
	repeat_attacks = true
	complete_attack_sequence = true
	move_speed = 120

func setProjectileScene() -> void:
	PROJECTILE_SCENE = preload('res://Resources/Abilities/TelegraphedAOE/TelegraphedAOE.tscn')
