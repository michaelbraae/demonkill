extends "res://Resources/Scripts/NPC/PossessableAI.gd"

var attacks_in_sequence
var current_attack_in_sequence = 1
var attack_started = false
var has_attack_landed = false

func setAttacksInSequence(a_i_s) -> void:
	attacks_in_sequence = a_i_s

func getAttacksInSequence() -> int:
	return attacks_in_sequence

func setCurrentAttackInSequence(current_a_i_s) -> void:
	current_attack_in_sequence = current_a_i_s

func getCurrentAttackInSequence() -> int:
	return current_attack_in_sequence

func isPlayerInRange() -> bool:
	return false

func getAnimation() -> String:
	if [NAVIGATING, FOLLOWING_PLAYER, WANDERING].has(state):
		return getNavigationAnimation()
	if [PRE_ATTACK ,ATTACKING, POST_ATTACK].has(state):
		return getAttackAnimation()
	return "idle"

func getNavigationAnimation() -> String:
	if velocity.x >= 0.1:
		animatedSprite.flip_h = false
	if velocity.x <= -0.1:
		animatedSprite.flip_h = true
	return "run"

func setPreAttack() -> void:
	if not [PRE_ATTACK, ATTACKING, POST_ATTACK].has(state):
		attack_started = true
		state = PRE_ATTACK

func perAttackAction() -> void:
	pass

func getAttackAnimation():
	match state:
		PRE_ATTACK:
			return "pre_attack"
		ATTACKING:
			return "attack_" + str(getCurrentAttackInSequence())
		POST_ATTACK:
			return "post_attack"

func runDecisionTree():
	if player:
		alignRayCastToPlayer()
		detectBlockers()
		if isPlayerInRange() and not path_blocked or attack_started:
			setPreAttack()
			if state == ATTACKING:
				perAttackAction()
		else:
			.runDecisionTree()
	animatedSprite.play(getAnimation())

func handlePostAnimState() -> void:
	match state:
		PRE_ATTACK:
			state = ATTACKING
		ATTACKING:
			has_attack_landed = false
			attack_started = false
			setCurrentAttackInSequence(getCurrentAttackInSequence() + 1)
			if (
				getCurrentAttackInSequence() > 1
				and not isPlayerInRange()
				or	getCurrentAttackInSequence() > getAttacksInSequence()
			):
				state = POST_ATTACK
				setCurrentAttackInSequence(1)
		POST_ATTACK:
			state = IDLE
