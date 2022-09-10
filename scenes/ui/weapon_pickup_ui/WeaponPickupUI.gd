extends Control

onready var card_slot_1 = get_node("%WeaponCard")
onready var card_slot_2 = get_node("%WeaponCard2")
onready var card_slot_new = get_node("%WeaponCardNew")

# UI positions
onready var top_row = get_node("%TopPosition")
onready var bottom_row = get_node("%BottomPosition")
# this interface only appears when the player attempts to pick up a weapon with all weapons slots already full

var weapon_to_pickup: PackedScene

var selected_slot: int = 0

func initialise_weapon_pickups() -> void:
	card_slot_1.weapon = PlayerState.weapon_slot_1.instance()
	card_slot_2.weapon = PlayerState.weapon_slot_2.instance()
	card_slot_new.set_params()
	card_slot_1.set_params()
	card_slot_2.set_params()

func swap_selected_weapon() -> void:
	if selected_slot and weapon_to_pickup.can_instance():
		GameState.player.change_weapon_in_slot(weapon_to_pickup, selected_slot)
		visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		card_slot_new.rect_position = top_row.position
		selected_slot = 1
	if event.is_action_pressed("ui_down"):
		selected_slot = 2
		card_slot_new.rect_position = bottom_row.position
