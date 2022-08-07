extends Control

# when the object is initialised

var weapon: Weapon

func set_params() -> void:
	get_node("%Name").set_text(weapon.weapon_name)
	get_node("%Rarity").set_text(weapon.rarity)
	get_node("%Icon").set_texture(weapon.weapon_icon)
