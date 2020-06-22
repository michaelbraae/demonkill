extends PathfindingAI

class_name CombatReadyAI

var knockback_handler_script = preload("res://Resources/Scripts/Helpers/Behaviour/KnockBackHandler.gd")
var knockback_handler

var stun_damage_threshold = 3
var stun_duration_timer
var stun_duration = 3

# number of attacks to run before moving to POST_ATTACK
var attacks_in_sequence
var current_attack_in_sequence = 1

# used to ensure the attack_sequence is completed
var attack_started = false
var has_attack_landed = false

# if each "attacks_in_sequence" uses the same "attack" animation
var repeat_attacks = false

# units between player and self before considered in range
var attack_range

# determines if the AI should complete the entire sequence,
# before moving to POST_ATTACK
var complete_attack_sequence = false

# time in seconds (float) before the AI can attack again
var attack_cooldown
var attack_cooldown_timer

# time in seconds (float) before the AI can damage the player
# to prevent damage ticks stacking each swing
var damage_cooldown = 0.5
var damage_cooldown_timer

# starting health
var health = 10

func _ready():
	knockback_handler = knockback_handler_script.new()
	stun_duration_timer = Timer.new()
	add_child(stun_duration_timer)
	attack_cooldown_timer = Timer.new()
	add_child(attack_cooldown_timer)
	damage_cooldown_timer = Timer.new()
	add_child(damage_cooldown_timer)

func setStunDamageThreshold(s_d_t : int) -> void:
	stun_damage_threshold = s_d_t

func getStunDamageThreshold() -> int:
	return stun_damage_threshold

func setStunDuration(duration : int) -> void:
	stun_duration = duration

func getStunDuration() -> int:
	return stun_duration

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

func setDamageCooldown(cooldown : float) -> void:
	damage_cooldown = cooldown

func getDamageCooldown() -> float:
	return damage_cooldown

func damage(damage : int, use_cooldown : bool) -> void:
	if use_cooldown:
		if damage_cooldown_timer.is_stopped():
			damage_cooldown_timer.start(getDamageCooldown())
			health = health - damage
	else:
		health = health - damage
	if health <= getStunDamageThreshold():
		if health < 0:
			setState(PRE_DEATH)
		else:
			setState(STUNNED)

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

func readyForDamage() -> bool:
	return true

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
	if getState() == STUNNED:
		return "stunned"
	if getState() == PRE_DEATH:
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
	if getState() == STUNNED:
		knockback_handler.setKnockedBack(false)
	elif getState() == PRE_DEATH:
		pass
	elif knockback_handler.getKnockedBack():
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
		STUNNED:
			setState(IDLE)
		PRE_DEATH:
			queue_free()

func _process(delta):
	if damage_cooldown_timer.get_time_left() < 0.1:
		damage_cooldown_timer.stop()
	if stun_duration_timer.get_time_left() < 0.1:
		stun_duration_timer.stop()
