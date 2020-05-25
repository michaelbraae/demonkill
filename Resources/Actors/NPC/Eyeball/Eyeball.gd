extends CasterAI

func initialiseConfig() -> void:
	.initialiseConfig()
	setAttackRange(250)
	setMoveSpeed(120)
	setAttacksInSequence(1)
	setRepeatAttacks(true)
	setCompleteAttackSequence(true)

func setProjectileScene() -> void:
	PROJECTILE_SCENE = preload("res://Resources/Abilities/TelegraphedAOE/TelegraphedAOE.tscn")
