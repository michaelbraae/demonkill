extends PathfindingAI

class_name CombatReadyAI

var AXE_SCENE = preload("res://resources/abilities/axe_throw/AxeThrow.tscn")

onready var OUTLINE_SHADER = preload("res://assets/shaders/OutlineShader.tscn")

var stun_damage_threshold = 1
var stun_duration_timer
var stun_duration = 3

# used to ensure the attack_sequence is completed
var attack_started = false
var attack_landed = false

# units between player and self before considered in range
export var attack_range: float
export var ability_range: float
export var too_close_range = -1

# time in seconds (float) before the AI can attack again
export var attack_cooldown: float
var attack_cooldown_timer

# abilty cooldown handler
export var ability_cooldown: float
var ability_cooldown_timer
var ability_on_cooldown = false

# starting health
export var max_health: int
var health

var axeOutlineShader

# POSSESSION DURATION
var possession_duration_timer: Timer

# rng for deciding to drophealth
var rng = RandomNumberGenerator.new()

func addHealth(health_add: int) -> void:
	if health_add + health > max_health:
		health = max_health
	else:
		health += health_add
	

func setHealth() -> void:
	$EnemyUI/HealthBar.max_value = max_health
	$EnemyUI/HealthBar.value = health
	$EnemyUI/AbilityCooldown.max_value = ability_cooldown
	if is_instance_valid(possession_duration_timer):
		if possession_duration_timer.is_stopped():
			$EnemyUI/PossessionCooldownBar.visible = false
		else:
			$EnemyUI/PossessionCooldownBar.visible = true
			$EnemyUI/PossessionCooldownBar.max_value = possession_duration
			$EnemyUI/PossessionCooldownBar.value = possession_duration_timer.get_time_left()

	if is_instance_valid(ability_cooldown_timer):
		if ability_cooldown_timer.is_stopped():
			$EnemyUI/AbilityCooldown.visible = false
			$EnemyUI/AbilityCooldown.value = ability_cooldown
		else:
			$EnemyUI/AbilityCooldown.visible = true
			var cooldown_as_percentage = ability_cooldown_timer.get_time_left() / ability_cooldown
			$EnemyUI/AbilityCooldown.value = (cooldown_as_percentage * -1 + 1) * ability_cooldown

func _ready():
	health = max_health

	stun_duration_timer = Timer.new()
	add_child(stun_duration_timer)
	stun_duration_timer.connect('timeout', self, 'stun_duration_timeout')
	
	attack_cooldown_timer = Timer.new()
	add_child(attack_cooldown_timer)
	attack_cooldown_timer.connect('timeout', self, 'attack_cooldown_timeout')
	
	ability_cooldown_timer = Timer.new()
	add_child(ability_cooldown_timer)
	ability_cooldown_timer.connect('timeout', self, 'ability_cooldown_timeout')

	possession_duration_timer = Timer.new()
	add_child(possession_duration_timer)
	# warning-ignore:return_value_discarded
	possession_duration_timer.connect('timeout', self, 'possession_duration_timeout')

func stun_duration_timeout() -> void:
	stun_duration_timer.stop()

func attack_cooldown_timeout() -> void:
	attack_cooldown_timer.stop()

func resetAbilityCooldown() -> void:
	if is_instance_valid(ability_cooldown_timer):
		ability_cooldown_timer.stop()
	ability_on_cooldown = false

func ability_cooldown_timeout() -> void:
	ability_cooldown_timer.stop()
	ability_on_cooldown = false

func possession_duration_timeout() -> void:
	onPossessEnd()
	if isPossessed():
		PossessionState.exitPossession(position)

func dropAxe() -> void:
	if is_instance_valid(axeOutlineShader):
		axeOutlineShader.queue_free()
	state = IDLE
	GameState.npc_with_axe = null
	GameState.axe_instance = AXE_SCENE.instance()
	get_tree().get_root().add_child(GameState.axe_instance)
	GameState.axe_instance.position = get_global_position()

func damage(damage : int) -> void:
	attack_started = false
	health -= damage
	if GameState.npc_with_axe == self and not isPossessed():
		dropAxe()
	if isPossessed() and health <= 0:
		PossessionState.handlePossessionDeath(get_global_position())
	elif health <= 0:
		kill()

func readyForDamage() -> bool:
	return true

func isTargetInRange() -> bool:
	if is_instance_valid(target_actor):
		var distance_to_target = get_global_position().distance_to(
			target_actor.get_global_position()
		)
		if distance_to_target <= attack_range:
			return true
	return false

func isTargetInAbilityRange() -> bool:
	if is_instance_valid(target_actor):
		var distance_to_target = get_global_position().distance_to(
			target_actor.get_global_position()
		)
		if distance_to_target <= ability_range:
			return true
	return false

func isTargetTooClose() -> bool:
	if is_instance_valid(target_actor):
		var distance_to_target = get_global_position().distance_to(
			target_actor.get_global_position()
		)
		if distance_to_target <= too_close_range:
			return true
	return false

func getAnimation() -> String:
	if state == POSSESSION_RECOVERY:
		return "stunned"
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
			return 'attack'
		POST_ATTACK:
			return 'post_attack'
	return 'idle'

# get the angle of attack, using player input if possessed
func getAttackAngle() -> float:
	if isPossessed():
		return get_angle_to(get_global_mouse_position())
	elif is_instance_valid(target_actor):
		return get_angle_to(target_actor.get_global_position())
	return 0.0

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

var outline_shader
var possession_duration

func onPossess(new_possession_duration: float = -1) -> void:
	outline_shader = OUTLINE_SHADER.instance()
	outline_shader.texture = animatedSprite.get_sprite_frames().get_frame(getAnimation(), animatedSprite.frame)
	add_child(outline_shader)
	animatedSprite.visible = false
	if new_possession_duration > -1 and possession_duration_timer.is_stopped():
		possession_duration = new_possession_duration
		possession_duration_timer.start(new_possession_duration)

func onPossessEnd() -> void:
	if is_instance_valid(possession_duration_timer):
		possession_duration_timer.stop()
	animatedSprite.visible = true
	if is_instance_valid(outline_shader):
		outline_shader.queue_free()

func possessedDecisionLogic() -> void:
	if is_instance_valid(outline_shader):
		outline_shader.texture = animatedSprite.get_sprite_frames().get_frame(getAnimation(), animatedSprite.frame)
		outline_shader.flip_h = animatedSprite.flip_h
		outline_shader.self_modulate = animatedSprite.self_modulate
		outline_shader.scale = animatedSprite.scale
	if state == POSSESSION_TARGETING:
		pass
	elif knocked_back:
		velocity = getKnockBackProcessVector()
	elif state == ATTACKING:
		pass
	else:
		velocity = InputHandler.getVelocity(move_speed)
		velocity = move_and_slide(velocity)

var has_outline: bool = false

func runDecisionTree() -> void:
	if state == POSSESSION_RECOVERY:
		pass
	elif isPossessed():
		possessedDecisionLogic()
	elif [STUNNED, PRE_DEATH, WITH_AXE].has(state):
		if knocked_back:
			knockback_vector = move_and_slide(getKnockBackProcessVector())
	elif knocked_back:
		state = KNOCKED_BACK
		knockback_vector = move_and_slide(getKnockBackProcessVector())
	else:
		if is_instance_valid(target_actor):
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
				else:
					if isTargetInRange() or attack_started:
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
		POSSESSION_RECOVERY:
			state = IDLE
			$CollisionShape2D.disabled = false
		KNOCKED_BACK:
			state = IDLE
		PRE_ATTACK:
			state = ATTACKING
		ATTACKING:
			attack_started = false
			attack_landed = false
			state = POST_ATTACK
		POST_ATTACK:
			state = IDLE
		STUNNED:
			if stun_duration_timer.is_stopped():
				state = IDLE
		PRE_DEATH:
			queue_free()

func _process(_delta):
	if state == WITH_AXE:
		if not is_instance_valid(axeOutlineShader):
			axeOutlineShader = OUTLINE_SHADER.instance()
			add_child(axeOutlineShader)
		axeOutlineShader.texture = animatedSprite.get_sprite_frames().get_frame(getAnimation(), animatedSprite.frame)
		axeOutlineShader.flip_h = animatedSprite.flip_h
		axeOutlineShader.self_modulate = animatedSprite.self_modulate
	else:
		if is_instance_valid(axeOutlineShader):
			axeOutlineShader.queue_free()
	$AnimatedSprite/LightOccluder2D.visible = true
	animatedSprite.light_mask = 2
	if state == STUNNED:
		$AnimatedSprite/LightOccluder2D.visible = false
		animatedSprite.light_mask = 1

func beforeDeath() -> void:
	pass

func kill() -> void:
	beforeDeath()
	state = PRE_DEATH

func hitByAxe(damage) -> void:
	damage(damage)
	state = WITH_AXE
	animatedSprite.play('with_axe')

func basic_attack_available() -> bool:
	if [
		PRE_ATTACK,
		ATTACKING,
		POST_ATTACK
	].has(state):
		return false
	return true

func basic_attack() -> void:
	if basic_attack_available():
		state = ATTACKING
		perAttackAction()

func ability_available() -> bool:
	return true

func use_ability() -> void:
	if ability_available():
		if not ability_on_cooldown:
			state = ATTACKING
			ability_cooldown_timer.start(ability_cooldown)
			ability_on_cooldown = true
			useAbility()
