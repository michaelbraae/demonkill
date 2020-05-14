extends "res://Resources/Scripts/NPC/AttackerAI.gd"

onready var attackRange = $AttackRange
const BASIC_ATTACK_DAMAGE = 3
const HIT_FRAMES = [3, 4, 5]

func initialiseConfig():
	setAttacksInSequence(2)
	setMoveSpeed(200)

func isPlayerInRange() -> bool:
	var overlapping_areas = attackRange.get_overlapping_areas()
	if overlapping_areas:
		for area in overlapping_areas:
			if area.get_parent().get("IS_PLAYER"):
				return true
	return false

func perAttackAction() -> void:
	if (
		isPlayerInRange()
		and not getHasAttackLanded()
		and HIT_FRAMES.has(animatedSprite.get_frame())
	):
		setHasAttackLanded(true)
		getPlayer().damage(BASIC_ATTACK_DAMAGE)
