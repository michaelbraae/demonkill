extends PlayerAnimation

class_name PlayerAction

var SWIPE_SCENE = preload('res://resources/abilities/swipe/Swipe.tscn')
var AXE_SCENE = preload('res://resources/abilities/axe_throw/AxeThrow.tscn')

var dash_timer
var dash_cooldown_timer
var dash_available = true
var dash_started = false
var dash_vector

var next_spell : Dictionary

#var axe_instance
var axe_recall_available = false

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

func noWeaponMelee() -> void:
	var attack_instance
	if next_spell:
		attack_instance = next_spell["scene"].instance()
		next_spell = {}
	else:
		attack_instance = SWIPE_SCENE.instance()
	add_child(attack_instance)
	attack_instance.bang(getAttackDirection(), self)

func throwAxe() -> void:
	state = AXE_THROW
	GameState.axe_instance = AXE_SCENE.instance()
	get_parent().add_child(GameState.axe_instance)
	axe_recall_available = false
	GameState.axe_instance.bang(getAttackDirection(), self)

func recallAxe() -> void:
	state = AXE_RECALL
	if GameState.axe_instance:
		GameState.axe_instance.earlyCallback()
	else:
		GameState.axe_instance = AXE_SCENE.instance()
		get_parent().add_child(GameState.axe_instance)
		GameState.npc_with_axe.state = GameState.npc_with_axe.RECOVERY
		GameState.axe_instance.returnToPlayer(GameState.npc_with_axe)
		GameState.npc_with_axe = null

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
	elif state == AXE_THROW:
		pass
	else:
		setVelocity()
		if (
			Input.is_action_just_pressed('melee_attack')
			and basicAttackAvailable()
		):
			if velocity:
				setFacingDirection(round(rad2deg(velocity.angle())))
			attack_order = !attack_order
			noWeaponMelee()
			state = ATTACK_WARMUP
		if Input.is_action_just_pressed('throw_axe'):
			if has_axe:
				has_axe = false
				throwAxe()
			else:
				recallAxe()
			
	animatedSprite.play(getAnimation())
	velocity = move_and_slide(velocity)
