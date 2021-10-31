extends Node2D

var velocity = Vector2()
var aim_vector = Vector2()

var using_mouse = true
var mute_inputs = false

var current_actor
const SPEED = 180

func _ready():
	setDeadzones()

func getVelocity(move_speed) -> Vector2: 
	if mute_inputs:
		return velocity * move_speed
	return getMovementVector() * move_speed

func getMovementVector() -> Vector2:
	velocity.y = Input.get_action_strength('down') - Input.get_action_strength('up')
	velocity.x = Input.get_action_strength('right') - Input.get_action_strength('left')
	velocity = velocity.normalized()
	return velocity

func setDeadzones() -> void:
	InputMap.action_set_deadzone('aim_up', 0.1)
	InputMap.action_set_deadzone('aim_down', 0.1)
	InputMap.action_set_deadzone('aim_left', 0.1)
	InputMap.action_set_deadzone('aim_right', 0.1)
	InputMap.action_set_deadzone('up', 0.1)
	InputMap.action_set_deadzone('down', 0.1)
	InputMap.action_set_deadzone('left', 0.1)
	InputMap.action_set_deadzone('right', 0.1)

func setMouseMode() -> void:
	if using_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func getAttackDirection() -> Vector2:
	if using_mouse:
		return Vector2(current_actor.get_local_mouse_position().normalized())
	aim_vector = Vector2()
	aim_vector.y = Input.get_action_strength('aim_down') - Input.get_action_strength('aim_up')
	aim_vector.x = Input.get_action_strength('aim_right') - Input.get_action_strength('aim_left')
	aim_vector = aim_vector.normalized()
	if aim_vector:
		return aim_vector
	return getMovementVector()

func castSpell(slot_key: int) -> void:
	if PlayerState.SPELLS[str(slot_key)]:
		print("castSpell: ", PlayerState.SPELLS[str(slot_key)])
		var spell_instance = PlayerState.SPELLS[str(slot_key)]["scene"].instance()
#		spell_instance.collision
		spell_instance.target_vector = getAttackDirection()
		spell_instance.position = GameState.player.position
		spell_instance.add_child(spell_instance)
		if PlayerState.SPELLS[str(slot_key)]["count"] <= 1:
			PlayerState.SPELLS[str(slot_key)] = {}
		else:
			PlayerState.SPELLS[str(slot_key)]["count"] -= 1
	else:
		print("No spell in slot!")
	GameState.player_ui.updateSpellUI(PlayerState.SPELLS)

func _physics_process(_delta):
	if Input.is_action_just_pressed("spell_slot_1"):
		castSpell(0)
	if Input.is_action_just_pressed("spell_slot_2"):
		castSpell(1)
	if Input.is_action_just_pressed("spell_slot_3"):
		castSpell(2)
	if Input.is_action_just_pressed("spell_slot_4"):
		castSpell(3)

func _process(_delta):
	if Input.is_action_just_pressed('ui_cancel'):
		get_tree().quit()
	if Input.is_action_just_pressed('reload_town'):
		LevelManager.goto_scene('res://Scenes/Levels/Town.tscn')
