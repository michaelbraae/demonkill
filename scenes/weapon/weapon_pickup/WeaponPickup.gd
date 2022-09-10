extends Node2D

var amplitude := 3.0

var frequency := 5.0

onready var icon = $Sprite

var time: float = 0.0

onready var default_pos = icon.get_position()

export(PackedScene) var weapon

onready var weapon_pickup_ui = UIManager.get_node("WeaponPickupUI")

# warning-ignore-all:return_value_discarded

func _ready() -> void:
	InputEmitter.connect("interacted", self, "interacted")
	var weapon_instance = weapon.instance()
	$WeaponCard.weapon = weapon_instance
	$WeaponCard.set_params()
	$Sprite.set_texture(weapon_instance.weapon_icon)
	weapon_instance.queue_free()

func interacted() -> void:
	if $WeaponCard.visible:
		var slot_1_valid: bool = is_instance_valid(GameState.player.weapon_slot_1_instance)
		var slot_2_valid: bool = is_instance_valid(GameState.player.weapon_slot_2_instance)
		if slot_1_valid and slot_2_valid:
			if !weapon_pickup_ui.visible:
				weapon_pickup_ui.card_slot_new.weapon = weapon.instance()
				weapon_pickup_ui.weapon_to_pickup = weapon
				weapon_pickup_ui.initialise_weapon_pickups()
				weapon_pickup_ui.visible = true
			else:
				weapon_pickup_ui.swap_selected_weapon()
				queue_free()
		else:
			if slot_1_valid:
				GameState.player.change_weapon_in_slot(weapon, 2)
			elif slot_2_valid:
				GameState.player.change_weapon_in_slot(weapon, 1)
			queue_free()

func _process(delta: float) -> void:
	time += delta * frequency
	icon.set_position(default_pos + Vector2(0, sin(time) * amplitude))
	if get_global_position().distance_to(GameState.player.position) < 30:
		$WeaponCard.visible = true
	else:
		weapon_pickup_ui.visible = false
		$WeaponCard.visible = false
