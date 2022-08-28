extends PathfindingAI

class_name CombatReadyAI

# warning-ignore-all:return_value_discarded

var AXE_SCENE = preload("res://scenes/ability/axe_throw/AxeThrow.tscn")

onready var OUTLINE_SHADER = preload("res://assets/shaders/OutlineShader.tscn")

var stun_damage_threshold = 1
var stun_duration_timer
var stun_duration = 3

# used to ensure the attack_sequence is completed
var attack_started = false
var attack_landed = false

# units between player and self before considered in range
export var attack_range: float
#export var ability_range: float
export var too_close_range = -1

# starting health
export var max_health: int
var health

# POSSESSION DURATION
var possession_duration_timer: Timer

# rng for deciding to drophealth
var rng = RandomNumberGenerator.new()

func addHealth(health_add: int) -> void:
	if health_add + health > max_health:
		health = max_health
	else:
		health += health_add

func _process(_delta) -> void:
	setHealth()

func setHealth() -> void:
	$EnemyUI/HealthBar.max_value = max_health
	$EnemyUI/HealthBar.value = health
	if is_instance_valid(possession_duration_timer):
		if possession_duration_timer.is_stopped():
			$EnemyUI/PossessionCooldownBar.visible = false
		else:
			$EnemyUI/PossessionCooldownBar.visible = true
			$EnemyUI/PossessionCooldownBar.max_value = possession_duration
			$EnemyUI/PossessionCooldownBar.value = possession_duration_timer.get_time_left()

export(PackedScene) var weapon_selection
var weapon: Weapon

func _ready():
	health = max_health
	
	weapon = weapon_selection.instance()
	add_child(weapon)
	
	stun_duration_timer = Timer.new()
	add_child(stun_duration_timer)
	stun_duration_timer.connect('timeout', self, 'stun_duration_timeout')
	
	possession_duration_timer = Timer.new()
	add_child(possession_duration_timer)
	possession_duration_timer.connect('timeout', self, 'possession_duration_timeout')

func stun_duration_timeout() -> void:
	stun_duration_timer.stop()

func possession_duration_timeout() -> void:
	onPossessEnd()
	if isPossessed():
		PossessionState.exitPossession(position)

func dropAxe() -> void:
	state = IDLE
	GameState.npc_with_axe = null
	GameState.axe_instance = AXE_SCENE.instance()
	get_tree().get_root().add_child(GameState.axe_instance)
	GameState.axe_instance.position = get_global_position()

func damage(damage : int) -> void:
	state = IDLE
	attack_landed = false
	attack_started = false
	health -= damage
	if GameState.npc_with_axe == self and not isPossessed():
		dropAxe()
	if isPossessed() and health <= 0:
		PossessionState.handlePossessionDeath(get_global_position())
	elif health <= 0:
		state = PRE_DEATH

func isTargetInRange() -> bool:
	if is_instance_valid(target_actor):
		var distance_to_target = get_global_position().distance_to(
			target_actor.get_global_position()
		)
		if distance_to_target <= attack_range:
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
		if state == ATTACK_WARMUP:
			return 'pre_attack'
		if state == ATTACK_CONTACT:
			return 'attack'
		if state == ATTACK_RECOVERY:
			return 'post_attack'
		return getNavigationAnimation()
	if state == NAVIGATING:
		return getNavigationAnimation()
	if ATTACK_STATES.has(state):
		return getAttackAnimation()
	if state == KNOCKED_BACK:
		return 'take_hit'
	if state == STUNNED:
		return 'stunned'
	if state == PRE_DEATH:
		return 'take_hit'
	if state == AXE_INTERACTION:
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
		ATTACK_WARMUP:
			return 'pre_attack'
		ATTACK_CONTACT:
			return 'attack'
		ATTACK_RECOVERY:
			return 'post_attack'
	return 'idle'

# get the angle of attack, using player input if possessed
func getAttackAngle() -> float:
	if isPossessed():
		return get_angle_to(get_global_mouse_position())
	elif is_instance_valid(target_actor):
		return get_angle_to(target_actor.get_global_position())
	return 0.0

func getAttackDirection() -> Vector2:
	var angle = getAttackAngle()
	return Vector2(cos(angle), sin(angle))

func readyForPreAttack() -> bool:
	return not ATTACK_STATES.has(state)

func handlePreAttack() -> void:
	attack_started = true
	state = ATTACK_WARMUP

func basic_attack() -> void:
	attack()

func attack() -> void:
	if weapon.attack_available:
		attack_movement_vector = Vector2()
		state = ATTACK_WARMUP
		weapon.attack(getAttackDirection(), self)

var outline_shader
var possession_duration

func onPossess(new_possession_duration: float = -1) -> void:
	outline_shader = OUTLINE_SHADER.instance()
	weapon.attack_available = true
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
	else:
		set_player_input_velocity()
		# velocity = InputHandler.getVelocity(move_speed)
		velocity = move_and_slide(velocity)

var has_outline: bool = false

func runDecisionTree() -> void:
	if state == POSSESSION_RECOVERY:
		pass
	elif isPossessed():
		possessedDecisionLogic()
	elif [STUNNED, PRE_DEATH, AXE_INTERACTION].has(state):
		if knocked_back:
			knockback_vector = move_and_slide(getKnockBackProcessVector())
	elif knocked_back:
		state = KNOCKED_BACK
		knockback_vector = move_and_slide(getKnockBackProcessVector())
	else:
		if is_instance_valid(target_actor):
			if (
				isTargetInRange()
				and weapon.attack_available
				and not isTargetTooClose()
				and hasLineOfSight()
				or attack_started
			):
				if readyForPreAttack():
					handlePreAttack()
				elif state == ATTACK_CONTACT:
					attack()
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
		ATTACK_WARMUP:
			state = ATTACK_CONTACT
		ATTACK_CONTACT:
			attack_started = false
			attack_landed = false
			state = ATTACK_RECOVERY
		ATTACK_RECOVERY:
			state = IDLE
		STUNNED:
			if stun_duration_timer.is_stopped():
				state = IDLE
		PRE_DEATH:
			queue_free()

func hitByAxe(damage) -> void:
	damage(damage)
	state = AXE_INTERACTION
	animatedSprite.play('with_axe')
