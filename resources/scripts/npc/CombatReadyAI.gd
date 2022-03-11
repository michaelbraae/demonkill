extends PathfindingAI

class_name CombatReadyAI

var knockback_handler_script = preload("res://resources/scripts/helpers/KnockBackHandler.gd")
var knockback_handler

var AXE_SCENE = preload("res://resources/abilities/axe_throw/AxeThrow.tscn")

var Q_BUTTON_SCENE = preload("res://scenes/gui/buttons/ButtonQ.tscn")

var stun_damage_threshold = 1
var stun_duration_timer
var stun_duration = 3

# number of attacks to run before moving to POST_ATTACK
var attacks_in_sequence
var current_attack_in_sequence = 1

# used to ensure the attack_sequence is completed
var attack_started = false
var attack_landed = false

# if each 'attacks_in_sequence' uses the same 'attack' animation
var repeat_attacks = false

# units between player and self before considered in range
var attack_range
var ability_range
var too_close_range = -1

# determines if the AI should complete the entire sequence,
# before moving to POST_ATTACK
var complete_attack_sequence = false

# time in seconds (float) before the AI can attack again
var attack_cooldown
var attack_cooldown_timer

# abilty cooldown handler
var ability_cooldown
var ability_cooldown_timer
var ability_on_cooldown = false

# starting health
var max_health = 3
var health

# -- HEALTH PICKUP --
# health pickup scene
var HEALTH_PICKUP = preload("res://resources/pickups/health_pickup/HealthPickup.tscn")
# rng for deciding to drophealth
var rng = RandomNumberGenerator.new()

func _ready():
	health = max_health
	knockback_handler = knockback_handler_script.new()
	
	stun_duration_timer = Timer.new()
	add_child(stun_duration_timer)
	stun_duration_timer.connect('timeout', self, 'stun_duration_timeout')
	
	attack_cooldown_timer = Timer.new()
	add_child(attack_cooldown_timer)
	attack_cooldown_timer.connect('timeout', self, 'attack_cooldown_timeout')
	
	ability_cooldown_timer = Timer.new()
	add_child(ability_cooldown_timer)
	ability_cooldown_timer.connect('timeout', self, 'ability_cooldown_timeout')

func stun_duration_timeout() -> void:
	if is_instance_valid(get_node("ButtonQ")):
		get_node("ButtonQ").queue_free()
	stun_duration_timer.stop()

func attack_cooldown_timeout() -> void:
	attack_cooldown_timer.stop()

func ability_cooldown_timeout() -> void:
	ability_cooldown_timer.stop()
	ability_on_cooldown = false

func dropAxe() -> void:
	state = IDLE
	GameState.npc_with_axe = null
	GameState.axe_instance = AXE_SCENE.instance()
	get_tree().get_root().add_child(GameState.axe_instance)
	GameState.axe_instance.position = get_global_position()

func damage(damage : int) -> void:
	attack_started = false
	health -= damage
	if GameState.npc_with_axe == self:
		dropAxe()
	if isPossessed() and health <= 0:
		PossessionState.handlePossessionDeath(get_global_position())
	elif health <= stun_damage_threshold:
		if health <= 0 or state == STUNNED:
			kill()
#			queue_free()
		else:
			stun_duration_timer.start(stun_duration)
			state = STUNNED
			var q_button = Q_BUTTON_SCENE.instance()
			q_button.position.y = q_button.position.y - 30
			add_child(q_button)

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

func isTargetInRange() -> bool:
	var wr = weakref(target_actor)
	if wr.get_ref():
		var distance_to_target = get_global_position().distance_to(
			target_actor.get_global_position()
		)
		if distance_to_target <= attack_range:
			return true
	return false

func isTargetInAbilityRange() -> bool:
	var wr = weakref(target_actor)
	if wr.get_ref():
		var distance_to_target = get_global_position().distance_to(
			target_actor.get_global_position()
		)
		if distance_to_target <= ability_range:
			return true
	return false

func isTargetTooClose() -> bool:
	var distance_to_target = get_global_position().distance_to(
		target_actor.get_global_position()
	)
	if distance_to_target <= too_close_range:
		return true
	return false

func hasLineOfSight() -> bool:
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(get_global_position(), target_actor.get_global_position(), [self])
	if result and result['collider'] == GameState.player:
		return true
	return false

func getAnimation() -> String:
	if isPossessed():
		if state == ATTACKING:
			return 'attack_loop'
		return getNavigationAnimation()
	if [NAVIGATING, FOLLOWING_PLAYER, WANDERING].has(state):
		return getNavigationAnimation()
	if [PRE_ATTACK, ATTACKING, POST_ATTACK].has(state):
		return getAttackAnimation()
	if state == KNOCKED_BACK:
		return 'take_hit'
	if state == STUNNED:
		return 'stunned'
	if state == PRE_DEATH:
		return 'take_hit'
	if state == WITH_AXE:
		return 'with_axe'
	return 'idle'

func getNavigationAnimation() -> String:
	if velocity.x >= 0.1:
		animatedSprite.flip_h = false
		return 'run'
	if velocity.x <= -0.1:
		animatedSprite.flip_h = true
		return 'run'
	if velocity.y <= -0.1 or velocity.y >= 0.1:
		return 'run'
	return 'idle'

func getAttackAnimation() -> String:
	match state:
		PRE_ATTACK:
			return 'pre_attack'
		ATTACKING:
			if repeat_attacks:
				return 'attack'
			return 'attack_' + str(attacks_in_sequence)
		POST_ATTACK:
			return 'post_attack'
	return 'idle'

# get the angle of attack, using player input if possessed
func getAttackAngle() -> float:
	if isPossessed():
		return get_angle_to(get_global_mouse_position())
	else:
		return get_angle_to(target_actor.get_global_position())

func readyForPreAttack() -> bool:
	return (
		not [PRE_ATTACK, ATTACKING, POST_ATTACK].has(state)
		and attack_cooldown_timer.is_stopped()
	)

func handlePreAttack() -> void:
	attack_cooldown_timer.start(attack_cooldown)
	attack_started = true
	state = PRE_ATTACK

func perAttackAction() -> void:
	pass

func useAbility() -> void:
	pass

func readyForPostAttack() -> bool:
	if complete_attack_sequence:
		if current_attack_in_sequence > attacks_in_sequence:
			return true
	else:
		if (
			current_attack_in_sequence > 1
			and not isTargetInRange()
			or current_attack_in_sequence > attacks_in_sequence
		):
			return true
	return false

func possessedDecisionLogic() -> void:
	if knockback_handler.knocked_back:
		velocity = knockback_handler.getKnockBackProcessVector()
	elif (
		Input.is_action_just_pressed("melee_attack")
		or Input.is_action_just_pressed("use_ability")
		or state == ATTACKING
	):
		if not attack_started:
			attack_started = true
			if Input.is_action_just_pressed("melee_attack"):
				perAttackAction()
			elif Input.is_action_just_pressed("use_ability"):
				useAbility()
		state = ATTACKING
	else:
		velocity = InputHandler.getVelocity(move_speed)
		velocity = move_and_slide(velocity)

func runDecisionTree() -> void: 
	if isPossessed():
		possessedDecisionLogic()
	elif [STUNNED, PRE_DEATH, WITH_AXE].has(state):
		pass
	elif knockback_handler.knocked_back:
		state = KNOCKED_BACK
		knockback_handler.vector = move_and_slide(knockback_handler.getKnockBackProcessVector())
	else:
		if target_actor:
			if (
				isTargetInRange()
				or (isTargetInAbilityRange() and not ability_on_cooldown and hasLineOfSight())
				or attack_started
				or state == POST_ATTACK
			):
				if isTargetInAbilityRange() and not ability_on_cooldown and not isTargetTooClose():
					if readyForPreAttack():
						handlePreAttack()
					elif state == ATTACKING and not attack_landed:
						useAbility()
						ability_cooldown_timer.start(ability_cooldown)
						ability_on_cooldown = true
						attack_landed = true
				elif isTargetInRange() or attack_started:
					if readyForPreAttack():
						handlePreAttack()
					elif state == ATTACKING and not attack_landed:
						perAttackAction()
						attack_landed = true
				else:
					.runDecisionTree()
			else:
				.runDecisionTree()
	animatedSprite.play(getAnimation())

func handlePostAnimState() -> void:
	match state:
		KNOCKED_BACK:
			state = IDLE
		PRE_ATTACK:
			state = ATTACKING
		ATTACKING:
			current_attack_in_sequence += 1
			if readyForPostAttack():
				attack_started = false
				state = POST_ATTACK
				current_attack_in_sequence = 1
		POST_ATTACK:
			attack_landed = false
			state = IDLE
		STUNNED:
			if stun_duration_timer.is_stopped():
				state = IDLE
		PRE_DEATH:
			queue_free()

func _process(_delta):
	$AnimatedSprite/LightOccluder2D.visible = true
	animatedSprite.light_mask = 2
	if state == STUNNED:
		$AnimatedSprite/LightOccluder2D.visible = false
		animatedSprite.light_mask = 1

func beforeDeath() -> void:
	rng.randomize()
	if rng.randf() > 0:
		var health_pickup = HEALTH_PICKUP.instance()
		health_pickup.position.x = health_pickup.position.x + 50
		add_child(health_pickup)

func kill() -> void:
	beforeDeath()
	state = PRE_DEATH

func hitByAxe(damage) -> void:
	damage(damage)
	state = WITH_AXE
	animatedSprite.play('with_axe')
