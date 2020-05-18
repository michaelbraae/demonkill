extends AttackerAI

const BASIC_ATTACK_DAMAGE = 0

func initialiseConfig():
	setAttacksInSequence(1)
	setMoveSpeed(180)
	setAttackRange(50)
	setRepeatAttacks(true)

func perAttackAction() -> void:
	if (
		isPlayerInRange()
		and not getHasAttackLanded()
	):
		setHasAttackLanded(true)
		getPlayer().damage(BASIC_ATTACK_DAMAGE)
