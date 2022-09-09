extends Control

onready var card_slot_1 = get_node("%WeaponCard")
onready var card_slot_2 = get_node("%WeaponCard2")
onready var cards_slot_new = get_node("%WeaponCardNew")

# this interface only appears when the player attempts to pick up a weapon with all weapons slots already full

func initialise_weapon_pickups() -> void:
	card_slot_1.weapon = PlayerState.weapon_slot_1.instance()
	card_slot_2.weapon = PlayerState.weapon_slot_2.instance()
	cards_slot_new.set_params()
	card_slot_1.set_params()
	card_slot_2.set_params()
