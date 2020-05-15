extends AttackerAI

const BASIC_ATTACK_DAMAGE = 3
const HIT_FRAMES = [3, 4, 5]

func initialiseConfig():
	setAttacksInSequence(2)
	setMoveSpeed(200)
	setAttackRange(50)

func perAttackAction() -> void:
	if (
		isPlayerInRange()
		and not getHasAttackLanded()
		and HIT_FRAMES.has(animatedSprite.get_frame())
	):
		setHasAttackLanded(true)
		getPlayer().damage(BASIC_ATTACK_DAMAGE)
