extends Control

onready var label = $PressESCforHelp
onready var healthBar = $HealthBar

var health_current
var max_health

func _physics_process(_delta) -> void:
	if GameState.state == GameState.CONTROLLING_NPC and is_instance_valid(PossessionState.current_possession):
		health_current = PossessionState.current_possession.health
		max_health = PossessionState.current_possession.max_health
	else:
		health_current = PlayerState.health
		max_health = PlayerState.max_health
	healthBar.max_value = max_health
	healthBar.value = health_current
	
	$ManaBar.max_value = PlayerState.max_mana
	$ManaBar.value = PlayerState.mana
	
	if is_instance_valid(GameState.player):
		$HBoxContainer/DashCooldown.text = str(stepify(GameState.player.possession_dash_cooldown_timer.get_time_left(), 0.1))

func add_weapon_icon_to_ui_slot(weapon_icon, slot: int) -> void:
	match slot:
		1: get_node("%Slot1Icon").texture = weapon_icon
		2: get_node("%Slot2Icon").texture = weapon_icon

func clear_icon_from_slot(slot: int) -> void:
	match slot:
		1: get_node("%Slot1Icon").set_texture(null)
		2: get_node("%Slot2Icon").set_texture(null)
