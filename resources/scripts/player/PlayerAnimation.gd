extends PlayerNavigation

class_name PlayerAnimation

var attack_order = false
var has_axe = true

const DASH_GHOST_SCENE = preload('res://resources/actors/player/dash_ghost/DashGhost.tscn')
var dash_ghost_cooldown_timer: Timer

func _ready() -> void:
	dash_ghost_cooldown_timer = Timer.new()
	dash_ghost_cooldown_timer.connect("timeout", self, "dash_ghost_timeout")
	add_child(dash_ghost_cooldown_timer)

func setFacingDirection(angle_of_focus : int) -> void:
	if angle_of_focus < -30 and angle_of_focus > -150:
		animatedSprite.flip_h = false
		facing_direction = 'up'
	elif angle_of_focus >= -30 and angle_of_focus < 30:
		animatedSprite.flip_h = false
		facing_direction = 'right'
	elif angle_of_focus >= 30 and angle_of_focus <= 150:
		animatedSprite.flip_h = false
		facing_direction = 'down'
	elif angle_of_focus > 150 or angle_of_focus < -150:
		animatedSprite.flip_h = true
		facing_direction = 'right'

func getAnimationFromAngleOfFocus(angle_of_focus : int) -> String:
	setFacingDirection(angle_of_focus)
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
	if state == AXE_THROW:
		return 'axe_throw_' + facing_direction
	if state == DASH:
		animation = 'dash_'
	elif state == DASH_RECOVERY:
		animation = 'dash_recovery_'
	elif ATTACK_STATES.has(state):
		return getAttackAnimation()
	elif velocity:
		return getAnimationFromAngleOfFocus(round(rad2deg(velocity.angle())))
	else:
		return animation + facing_direction + getAnimationWeaponModifier()
	return animation + facing_direction

func _on_AnimatedSprite_animation_finished():
	if state == POSSESSION_TARGETING:
		pass
	elif [DASH_RECOVERY, ATTACK_RECOVERY, AXE_THROW].has(state):
		state = IDLE
		animatedSprite.play(str('idle_', facing_direction))
	elif state == ATTACK_WARMUP:
		state = ATTACK_CONTACT
		animatedSprite.play(getAttackAnimation())
	elif state == ATTACK_CONTACT:
		state = ATTACK_RECOVERY
		animatedSprite.play(getAttackAnimation())
