extends CasterAI

func initialiseConfig() -> void:
	.initialiseConfig()
	setAttackRange(250)
	setAttackCooldown(2)
	setAttacksInSequence(1)
	setRepeatAttacks(true)
	setCompleteAttackSequence(true)
	setMoveSpeed(120)

func setProjectileScene() -> void:
	PROJECTILE_SCENE = preload("res://Resources/Abilities/TelegraphedAOE/TelegraphedAOE.tscn")
