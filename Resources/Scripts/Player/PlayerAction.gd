extends PlayerAnimation

class_name PlayerAction

var SWIPE_SCENE = preload('res://Resources/Abilities/Swipe/Swipe.tscn')
var AXE_SCENE = preload('res://Resources/Abilities/AxeThrow/AxeThrow.tscn')

var dash_timer
var dash_cooldown_timer
var dash_available = true
var dash_started = false
var dash_vector

func _ready():
	dash_timer = Timer.new()
	dash_timer.connect('timeout', self, 'dash_timeout')
	add_child(dash_timer)
	dash_cooldown_timer = Timer.new()
	dash_cooldown_timer.connect('timeout', self, 'dash_cooldown_timeout')
	add_child(dash_cooldown_timer)

func dash_timeout() -> void:
	dash_timer.stop()
	dash_started = false
	state = DASH_RECOVERY

func dash_cooldown_timeout() -> void:
	dash_cooldown_timer.stop()
	dash_available = true

func swipe() -> void:
	var swipe_instance = SWIPE_SCENE.instance()
	add_child(swipe_instance)
	swipe_instance.bang(getAttackDirection(), self)

func throwAxe() -> void:
	var axe_instance = AXE_SCENE.instance()
	get_parent().add_child(axe_instance)
	axe_instance.bang(getAttackDirection(), self)

func basicAttackAvailable() -> bool:
	if [
		DASH,
		DASH_RECOVERY,
		ATTACK_WARMUP,
		ATTACK_CONTACT,
	].has(state):
		return false
	return true

func _physics_process(_delta : float) -> void:
	handlePlayerAction()

func handlePlayerAction() -> void:
	if state == DASH:
		if not dash_started:
			dash_started = true
			if velocity:
				dash_vector = InputHandler.getMovementVector()
			else:
				dash_vector = getVectorFromFacingDirection()
			velocity = dash_vector * 450
	elif state == DASH_RECOVERY:
		velocity = dash_vector * 50
	elif Input.is_action_just_pressed('dash') and dash_available:
		dash_available = false
		state = DASH
		dash_cooldown_timer.start(0.4)
		dash_timer.start(0.15)
	else:
		setVelocity()
		if (
			Input.is_action_just_pressed('melee_attack')
			and basicAttackAvailable()
		):
			if velocity:
				setFacingDirection(round(rad2deg(velocity.angle())))
			attack_order = !attack_order
			swipe()
			state = ATTACK_WARMUP
		if Input.is_action_just_pressed('throw_axe'):
			throwAxe()
	animatedSprite.play(getAnimation())
	velocity = move_and_slide(velocity)
