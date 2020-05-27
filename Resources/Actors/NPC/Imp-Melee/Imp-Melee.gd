extends MeleeAI

func initialiseConfig():
	setAttacksInSequence(1)
	setMoveSpeed(150)
	setAttackRange(50)
	setBasicAttackDamage(0)
	setRepeatAttacks(true)
	setCompleteAttackSequence(true)
	setAttackNodeRange(35)
	setAttackCooldown(1)
