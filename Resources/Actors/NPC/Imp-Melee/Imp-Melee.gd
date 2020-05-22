extends MeleeAI

const BASIC_ATTACK_DAMAGE = 0

func initialiseConfig():
	setAttacksInSequence(1)
	setMoveSpeed(130)
	setAttackRange(50)
	setRepeatAttacks(true)
	setCompleteAttackSequence(true)
	setAttackNodeRange(35)

func perAttackAction() -> void:
	.perAttackAction()
	if (
		isPlayerInRange()
		and not getHasAttackLanded()
	):
		setAttackStarted(true)
		setHasAttackLanded(true)
		getPlayer().damage(BASIC_ATTACK_DAMAGE)



