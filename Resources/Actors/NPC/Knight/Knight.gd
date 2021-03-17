extends CombatReadyAI

const BASIC_ATTACK_DAMAGE = 3
const HIT_FRAMES = [3, 4, 5]

func initialiseConfig():
	setAttacksInSequence(2)
	setMoveSpeed(200)
	setAttackRange(50)

func perAttackAction() -> void:
	if (
		isTargetInRange()
		and not getHasAttackLanded()
		and HIT_FRAMES.has(animatedSprite.get_frame())
	):
		setHasAttackLanded(true)
		getTarget().damage(BASIC_ATTACK_DAMAGE)
