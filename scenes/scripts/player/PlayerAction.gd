extends PlayerAnimation

class_name PlayerAction

# warning-ignore-all:return_value_discarded

var AXE_SCENE = preload('res://scenes/ability/axe_throw/AxeThrow.tscn')

var next_spell : Dictionary

var axe_recall_available = false

export(PackedScene) var weapon_default

var weapon_slot_1_instance
var weapon_slot_2_instance

var sprint_timer: Timer

func _ready() -> void:
	equip_weapons()
	
	sprint_timer = Timer.new()
	sprint_timer.connect("timeout", self, "sprint_timeout")
	add_child(sprint_timer)
	restart_sprint_timer()

func equip_weapons() -> void:
	if PlayerState.weapon_slot_1:
		weapon_slot_1_instance = PlayerState.weapon_slot_1.instance()
	else:
		weapon_slot_1_instance = weapon_default.instance()
	add_child(weapon_slot_1_instance)
	if PlayerState.weapon_slot_2:
		weapon_slot_2_instance = PlayerState.weapon_slot_2.instance()
	else:
		weapon_slot_2_instance = weapon_default.instance()
	add_child(weapon_slot_2_instance)

func change_weapon_in_slot(weapon: PackedScene, slot: int) -> void:
	if slot == 1:
		weapon_slot_1_instance.drop_weapon()
		weapon_slot_1_instance.queue_free()
		PlayerState.weapon_slot_1 = weapon
		weapon_slot_1_instance = weapon.instance()
		add_child(weapon_slot_1_instance)
	elif slot == 2:
		weapon_slot_2_instance.queue_free()
		PlayerState.weapon_slot_2 = weapon
		weapon_slot_2_instance = weapon.instance()
		add_child(weapon_slot_2_instance)

func sprint_timeout() -> void:
	sprint = true

func basic_attack() -> void:
	if weapon_slot_1_instance.attack_available:
		# warning-ignore:narrowing_conversion
		setFacingDirection(round(rad2deg(getAttackDirection().angle())))
		attack_order = !attack_order
		state = ATTACK_WARMUP
		weapon_slot_1_instance.attack(getAttackDirection(), self)
		attack_queued = false
	elif !attack_queued:
		queue_attack(1)

func queue_attack(_slot: int) -> void:
	if [ATTACK_CONTACT, ATTACK_RECOVERY].has(state):
		attack_queued = true

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

func hasPlayerPerformedAction() -> bool:
	if (
		Input.is_action_just_pressed("action_1") ||
		Input.is_action_just_pressed("action_2") ||
		Input.is_action_just_pressed("action_3") ||
		Input.is_action_just_pressed("ui_accept")
	):
		return true
	return false

func restart_sprint_timer() -> void:
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
#	elif ATTACK_STATES.has(state):
#		pass
	else:
		setVelocity()
	animatedSprite.play(getAnimation())
	if hasPlayerPerformedAction():
		restart_sprint_timer()
	elif sprint:
		velocity *= 1.5
	if not velocity:
		restart_sprint_timer()
	velocity = move_and_slide(velocity)
