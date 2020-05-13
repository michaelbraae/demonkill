extends "res://Resources/Scripts/NPC/PossessableAI.gd"

var attacks_in_sequence
var current_attack_in_sequence

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

func getNavigationAnimation():
	if velocity.x >= 0.1:
		animatedSprite.flip_h = false
	if velocity.x <= -0.1:
		animatedSprite.flip_h = true
	return "run"



func setPreAttack() -> void:
	if not [PRE_ATTACK, ATTACKING, POST_ATTACK].has(state):
		state = PRE_ATTACK

func getAttackAnimation():
	match state:
		PRE_ATTACK:
			return "pre_attack"
		ATTACKING:
			return "attack_" + str(getCurrentAttackInSequence())
		POST_ATTACK:
			return "post_attack"

func handleNavigation():
	if player:
		alignRayCastToPlayer()
		detectBlockers()
		if isPlayerInRange() and not path_blocked:
			pass
		else:
			.handleNavigation()

func handlePostAnimState() -> void:
	match state:
		PRE_ATTACK:
			state = ATTACKING
		ATTACKING:
			state = POST_ATTACK
		
	
# while the AI is attacking, we should check it's state. 
