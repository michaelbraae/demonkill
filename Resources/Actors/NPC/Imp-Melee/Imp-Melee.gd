extends MeleeAI

const BASIC_ATTACK_DAMAGE = 0

func initialiseConfig():
	setAttacksInSequence(1)
	setMoveSpeed(180)
	setAttackRange(50)
	setRepeatAttacks(true)
	setAttackNodeRange(35)

func perAttackAction() -> void:
	.perAttackAction()
#	.perAttackAction()
	if (
		isPlayerInRange()
		and not getHasAttackLanded()
	):
		setHasAttackLanded(true)
		getPlayer().damage(BASIC_ATTACK_DAMAGE)
