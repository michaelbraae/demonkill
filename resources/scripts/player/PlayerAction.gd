extends PlayerAnimation

class_name PlayerAction

var SWIPE_SCENE = preload('res://resources/abilities/swipe/Swipe.tscn')
var AXE_SCENE = preload('res://resources/abilities/axe_throw/AxeThrow.tscn')
onready var RUSTY_SWORD_SCENE = preload("res://scenes/weapon/swords/RustySword.tscn")

var next_spell : Dictionary

var axe_recall_available = false


export(PackedScene) var weapon_slot_1
export(PackedScene) var weapon_slot_2

var weapon_slot_1_instance

var sprint_timer: Timer

# warning-ignore-all:return_value_discarded

func _ready() -> void:
	weapon_slot_1_instance = weapon_slot_1.instance()
	add_child(weapon_slot_1_instance)
	
	sprint_timer = Timer.new()
	sprint_timer.connect("timeout", self, "sprint_timeout")
	add_child(sprint_timer)
	restartSprintTimer()

func sprint_timeout() -> void:
	sprint = true

func basic_attack() -> void:
	if weapon_slot_1_instance.attack_available:
		if velocity:
			# warning-ignore:narrowing_conversion
			setFacingDirection(round(rad2deg(velocity.angle())))
		attack_order = !attack_order
		state = ATTACK_WARMUP
		weapon_slot_1_instance.attack(getAttackDirection(), self)

func use_ability() -> void:
	if has_axe:
		throwAxe()
	else:
		recallAxe()

func throwAxe() -> void:
	if PlayerState.mana >= 1:
		has_axe = false
		PlayerState.useMana(2)
		state = AXE_INTERACTION
		GameState.axe_instance = AXE_SCENE.instance()
		get_parent().add_child(GameState.axe_instance)
		axe_recall_available = false
		GameState.axe_instance.bang(getAttackDirection(), self)

func interruptAction() -> void:
	state = IDLE

func recallAxe() -> void:
	if GameState.axe_instance:
		GameState.axe_instance.earlyCallback()
	else:
		GameState.axe_instance = AXE_SCENE.instance()
		get_parent().add_child(GameState.axe_instance)
		GameState.npc_with_axe.state = GameState.npc_with_axe.IDLE
		GameState.axe_instance.returnToPlayer(GameState.npc_with_axe)
		GameState.npc_with_axe = null

func basic_attack_available() -> bool:
	if [
		DASH,
		DASH_RECOVERY,
		ATTACK_WARMUP,
		ATTACK_CONTACT,
	].has(state):
		return false
	return true

func hasPlayerPerformedAction() -> bool:
	if (
		Input.is_action_just_pressed("action_1") ||
		Input.is_action_just_pressed("action_2") ||
		Input.is_action_just_pressed("action_3") ||
		Input.is_action_just_pressed("ui_accept") ||
		Input.is_action_just_pressed("possess")
	):
		return true
	return false

func restartSprintTimer() -> void:
	sprint = false
	sprint_timer.start(3)

func _physics_process(_delta : float) -> void:
	handlePlayerAction()

func handlePlayerAction() -> void:
	if state == DASH or state == POSSESSION_DASH:
		continueDash()
	elif state == DASH_RECOVERY:
		velocity = dash_vector * 50
	elif state == AXE_INTERACTION:
		pass
	else:
		setVelocity()
	animatedSprite.play(getAnimation())
	if hasPlayerPerformedAction():
		restartSprintTimer()
	elif sprint:
		velocity *= 1.5
	if not velocity:
		restartSprintTimer()
	velocity = move_and_slide(velocity)
