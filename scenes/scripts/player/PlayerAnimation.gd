extends PlayerBase

class_name PlayerAnimation

# warning-ignore-all:return_value_discarded

var attack_order = false
var has_axe = true

const DASH_GHOST_SCENE = preload('res://scenes/vfx/dash_ghost/DashGhost.tscn')
var dash_ghost_cooldown_timer: Timer
var sprint_ghost_cooldown_timer: Timer

var sprint: bool = false

var attack_queued: bool = false

func _ready() -> void:
	dash_ghost_cooldown_timer = Timer.new()
	dash_ghost_cooldown_timer.connect("timeout", self, "dash_ghost_timeout")
	add_child(dash_ghost_cooldown_timer)
	
	sprint_ghost_cooldown_timer = Timer.new()
	
	sprint_ghost_cooldown_timer.connect("timeout", self, "sprint_ghost_timeout")
	add_child(sprint_ghost_cooldown_timer)

func _physics_process(_delta) -> void:
	if sprint:
		sprint_ghost()

func getAnimationFromAngleOfFocus(angle_of_focus : int) -> String:
	set_facing_direction(angle_of_focus)
	return 'run_' + facing_direction + getAnimationWeaponModifier()

func getAttackOrder() -> String:
	if attack_order:
		return '1'
	return '2'

func getAnimationWeaponModifier() -> String:
	if has_axe:
		return '_axe'
	return ''

func dash_ghost() -> void:
	if dash_ghost_cooldown_timer.is_stopped():
		dash_ghost_cooldown_timer.start(0.05)
		var ghost: Sprite = DASH_GHOST_SCENE.instance()
		ghost.texture = animatedSprite.get_sprite_frames().get_frame(getAnimation(), animatedSprite.get_frame())
		ghost.position = position
		ghost.flip_h = animatedSprite.flip_h
		get_parent().add_child(ghost)

func dash_ghost_timeout() -> void:
	dash_ghost_cooldown_timer.stop()

func on_dash_continuous() -> void:
	.on_dash_continuous()
	dash_ghost()

func sprint_ghost() -> void:
	if sprint_ghost_cooldown_timer.is_stopped():
		sprint_ghost_cooldown_timer.start(0.15)
		var ghost: Sprite = DASH_GHOST_SCENE.instance()
		ghost.texture = animatedSprite.get_sprite_frames().get_frame(getAnimation(), animatedSprite.get_frame())
		# we want the sprint ghost to spawn behind the player
		ghost.position = position + velocity.normalized() * 13 * -1
		ghost.flip_h = animatedSprite.flip_h
		get_parent().add_child(ghost)

func sprint_ghost_timeout() -> void:
	sprint_ghost_cooldown_timer.stop()

func getAttackAnimation() -> String:
	var phase
	match state:
		POSSESSION_TARGETING:
			phase = "warmup"
		ATTACK_WARMUP:
			phase = 'warmup'
		ATTACK_CONTACT:
			phase = 'contact'
		ATTACK_RECOVERY:
			phase = 'recovery'
	if facing_direction == 'right':
		return 'attack' + getAnimationWeaponModifier() + '_' + phase + '_' + facing_direction + '_' + getAttackOrder()
	if attack_order:
		animatedSprite.flip_h = true
	else:
		animatedSprite.flip_h = false
	return 'attack' + getAnimationWeaponModifier() + '_' + phase + '_' + facing_direction

func getAnimation() -> String:
	var animation = 'idle_'
	if state == POSSESSION_TARGETING:
		return getAttackAnimation()
	if state == AXE_INTERACTION:
		return 'axe_throw_' + facing_direction
	if state == DASH:
		animation = 'dash_'
	elif state == DASH_RECOVERY:
		animation = 'dash_recovery_'
	elif ATTACK_STATES.has(state):
		return getAttackAnimation()
	elif velocity:
		# warning-ignore:narrowing_conversion
		return getAnimationFromAngleOfFocus(round(rad2deg(velocity.angle())))
	else:
		return animation + facing_direction + getAnimationWeaponModifier()
	return animation + facing_direction

func _on_AnimatedSprite_animation_finished():
	if state == POSSESSION_TARGETING:
		pass
	elif [DASH_RECOVERY, AXE_INTERACTION].has(state):
		state = IDLE
		animatedSprite.play(str('idle_', facing_direction))
	elif state == ATTACK_WARMUP:
		state = ATTACK_CONTACT
		animatedSprite.play(getAttackAnimation())
	elif state == ATTACK_CONTACT:
		state = ATTACK_RECOVERY
		animatedSprite.play(getAttackAnimation())
	elif state == ATTACK_RECOVERY:
		if attack_queued:
			basic_attack()
		else:
			state = IDLE
			
