extends Control

onready var card_slot_1 = get_node("%WeaponCard")
onready var card_slot_2 = get_node("%WeaponCard2")
onready var card_slot_new = get_node("%WeaponCardNew")

# UI positions
onready var top_position = get_node("%TopPosition")
onready var middle_position = get_node("%MiddlePosition")
onready var bottom_position = get_node("%BottomPosition")

var weapon_to_pickup: PackedScene

var selected_slot: int = 0

var t = 0

func initialise_weapon_pickups() -> void:
	reset_ui()
	card_slot_1.weapon = PlayerState.weapon_slot_1.instance()
	card_slot_2.weapon = PlayerState.weapon_slot_2.instance()
	card_slot_new.set_params()
	card_slot_1.set_params()
	card_slot_2.set_params()

func reset_ui() -> void:
	selected_slot = 0
	card_slot_new.rect_position = middle_position.position
	card_slot_new.clear_params()
	card_slot_1.clear_params()
	card_slot_2.clear_params()

func swap_selected_weapon() -> void:
	if selected_slot and weapon_to_pickup.can_instance():
		GameState.player.change_weapon_in_slot(weapon_to_pickup, selected_slot)
		visible = false

var position_target

func _unhandled_input(event):
	if !get_tree().paused:
		if event.is_action_pressed("ui_up"):
			if !position_target:
				selected_slot = 1
				t = 0
				position_target = top_position
		if event.is_action_pressed("ui_down"):
			if !position_target:
				selected_slot = 2
				t = 0
				position_target = bottom_position

func _physics_process(delta) -> void:
	if position_target and card_slot_new.rect_position != position_target.position:
			var lerp_distance = lerp(card_slot_new.rect_position, position_target.position, t)
			card_slot_new.rect_position = lerp_distance
			
			t += delta * 3

	if position_target and card_slot_new.rect_position.distance_to(position_target.position) < 10:
		card_slot_new.rect_position = position_target.position
		position_target = null
