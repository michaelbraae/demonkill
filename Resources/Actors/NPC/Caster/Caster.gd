extends CasterAI

func initialiseConfig() -> void:
	.initialiseConfig()
	setAttackRange(350)
	setMoveSpeed(180)
	setAttacksInSequence(5)
	setRepeatAttacks(true)
	setCompleteAttackSequence(true)

func setProjectileScene() -> void:
	PROJECTILE_SCENE = preload("res://Resources/Projectiles/Energy-Ball/Energy-Ball.tscn")
