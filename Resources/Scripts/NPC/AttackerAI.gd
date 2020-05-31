extends PathfindingAI

class_name AttackerAI

var knockback_handler_script = preload("res://Resources/Scripts/Helpers/Behaviour/KnockBackHandler.gd")
var knockback_handler

var attacks_in_sequence
var current_attack_in_sequence = 1
var attack_started = false
var has_attack_landed = false
var repeat_attacks = false
var attack_range
var complete_attack_sequence = false
var attack_cooldown
var attack_cooldown_timer

var health = 0

func _ready():
	knockback_handler = knockback_handler_script.new()
	attack_cooldown_timer = Timer.new()
	add_child(attack_cooldown_timer)

func setAttacksInSequence(a_i_s : int) -> void:
	attacks_in_sequence = a_i_s

func getAttacksInSequence() -> int:
	return attacks_in_sequence

func setCurrentAttackInSequence(current_a_i_s : int) -> void:
	current_attack_in_sequence = current_a_i_s

func getCurrentAttackInSequence() -> int:
	return current_attack_in_sequence

func setAttackStarted(attack_started_var : bool) -> void:
	attack_started = attack_started_var

func getAttackStarted() -> bool:
	return attack_started

func setHasAttackLanded(landed_var) -> void:
	has_attack_landed = landed_var

func getHasAttackLanded() -> bool:
	return has_attack_landed

func setRepeatAttacks(repeats_var : bool) -> void:
	repeat_attacks = repeats_var

func getRepeatAttacks() -> bool:
	return repeat_attacks

func setAttackRange(attack_range_var : float) -> void:
	attack_range = attack_range_var

func getAttackRange() -> float:
	return attack_range

func setCompleteAttackSequence(complete_sequence : bool) -> void:
	complete_attack_sequence = complete_sequence

func getCompleteAttackSequence() -> bool:
	return complete_attack_sequence

func setAttackCooldown(attack_cooldown_var : float) -> void:
	attack_cooldown = attack_cooldown_var

func getAttackCooldown() -> float:
	return attack_cooldown

func damage(damage : int) -> void:
	health = health - damage
	if health < 0:
		queue_free()

func knockBack(
	hit_direction : float,
	knock_back_speed : int,
	knock_back_decay : int
) -> void:
	knockback_handler.knockBack(
		hit_direction,
		knock_back_speed,
		knock_back_decay
	)

func isPlayerInRange() -> bool:
	var distance_to_player = get_global_position().distance_to(
		getPlayer().get_global_position()
	)
	if distance_to_player <= getAttackRange():
		return true
	return false

func getAnimation() -> String:
	if [NAVIGATING, FOLLOWING_PLAYER, WANDERING].has(getState()):
		return getNavigationAnimation()
	if [PRE_ATTACK, ATTACKING, POST_ATTACK].has(getState()):
		return getAttackAnimation()
	if getState() == KNOCKED_BACK:
		return "take_hit"
	return "idle"

func getNavigationAnimation() -> String:
	if velocity.x >= 0.1:
		animatedSprite.flip_h = false
	if velocity.x <= -0.1:
		animatedSprite.flip_h = true
	return "run"

func getAttackAnimation() -> String:
	match getState():
		PRE_ATTACK:
			return "pre_attack"
		ATTACKING:
			if getRepeatAttacks():
				return "attack"
			return "attack_" + str(getCurrentAttackInSequence())
		POST_ATTACK:
			return "post_attack"
	return "idle"

func readyForPreAttack() -> bool:
	return (
		not [PRE_ATTACK, ATTACKING, POST_ATTACK].has(getState())
		and attack_cooldown_timer.is_stopped()
	)

func handlePreAttack() -> void:
	attack_cooldown_timer.start(getAttackCooldown())
	setAttackStarted(true)
	setState(PRE_ATTACK)

func perAttackAction() -> void:
	pass

func readyForPostAttack() -> bool:
	if getCompleteAttackSequence():
		if getCurrentAttackInSequence() > getAttacksInSequence():
			return true
	else:
		if (
			getCurrentAttackInSequence() > 1
			and not isPlayerInRange()
			or getCurrentAttackInSequence() > getAttacksInSequence()
		):
			return true
	return false

func runDecisionTree() -> void:
	if knockback_handler.getKnockedBack():
		setAttackStarted(false)
		setState(KNOCKED_BACK)
		move_and_slide(knockback_handler.getKnockBackProcessVector())
	else:
		if attack_cooldown_timer.get_time_left() < 0.1:
			attack_cooldown_timer.stop()
		if getPlayer():
			alignRayCastToPlayer()
			detectBlockers()
			if (
				isPlayerInRange()
				and not getPathBlocked()
				or getAttackStarted()
				or getState() == POST_ATTACK
			):
				if readyForPreAttack():
					handlePreAttack()
				if getState() == ATTACKING:
					perAttackAction()
			else:
				.runDecisionTree()
	animatedSprite.play(getAnimation())

func handlePostAnimState() -> void:
	match getState():
		KNOCKED_BACK:
			setState(IDLE)
		PRE_ATTACK:
			setState(ATTACKING)
		ATTACKING:
			setHasAttackLanded(false)
			setCurrentAttackInSequence(getCurrentAttackInSequence() + 1)
			if readyForPostAttack():
				setAttackStarted(false)
				setState(POST_ATTACK)
				setCurrentAttackInSequence(1)
		POST_ATTACK:
			setState(IDLE)
