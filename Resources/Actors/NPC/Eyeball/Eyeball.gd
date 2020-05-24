extends CasterAI

func initialiseConfig() -> void:
	.initialiseConfig()
	setAttackRange(100)
	setMoveSpeed(120)
	setAttacksInSequence(5)
	setRepeatAttacks(true)
	setCompleteAttackSequence(true)

func setProjectileScene() -> void:
	PROJECTILE_SCENE = preload("res://Resources/Abilities/Projectiles/energy-ball/Energy-Ball.tscn")
