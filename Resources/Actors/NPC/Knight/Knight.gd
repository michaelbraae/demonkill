extends CombatReadyAI

const BASIC_ATTACK_DAMAGE = 1
const HIT_FRAMES = [3, 4, 5]

func initialiseConfig():
	move_speed = 200
	attacks_in_sequence = 2
	attack_range = 50

func perAttackAction() -> void:
	if (
		isTargetInRange()
		and not attack_landed
		and HIT_FRAMES.has(animatedSprite.get_frame())
	):
		attack_landed = true
		target_actor.damage(BASIC_ATTACK_DAMAGE)
