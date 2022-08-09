extends Control

var weapon: Weapon

onready var WEAPON_CARD_EFFECT = preload("res://scenes/weapon_card/weapon_card_effect/WeaponCardEffect.tscn")
onready var effect_list = get_node("%EffectList")

var card_colors: Dictionary = {
	"STRENGTH": {
		"background": ColorGlobal.strength_background,
		"border": ColorGlobal.strength_border,
		"heading_background": ColorGlobal.strength_heading_background,
		"details_background": ColorGlobal.strength_details_background,
	},
	"INTELLIGENCE": {
		"background": ColorGlobal.intelligence_background,
		"border": ColorGlobal.intelligence_border,
		"heading_background": ColorGlobal.intelligence_heading_background,
		"details_background": ColorGlobal.intelligence_details_background,
	},
	"VITALITY": {
		"background": ColorGlobal.vitality_background,
		"border": ColorGlobal.vitality_border,
		"heading_background": ColorGlobal.vitality_heading_background,
		"details_background": ColorGlobal.vitality_details_background,
	}
}

var rarity_colors: Dictionary = {
	"EXOTIC": ColorGlobal.exotic_color,
	"LEGENDARY": ColorGlobal.legendary_color,
	"RARE": ColorGlobal.rare_color,
	"COMMON": ColorGlobal.common_color
}

func set_params() -> void:
	get_node("%Name").set_text(weapon.weapon_name)
	set_rarity(weapon.rarity)
	set_colors(weapon.affinity)
	get_node("%Icon").set_texture(weapon.weapon_icon)
	set_effect_data()

func set_effect_data() -> void:
	for ability in weapon.attack_abilities:
		var ability_instance = ability.instance()
		for ability_effect in ability_instance.get_node("Effects").get_children():
			if ability_effect is DamageEffect:
				get_node("%DPSLabel").set_text(str(ability_effect.damage * weapon.attack_speed) + " DPS")
			if ability_effect is HealEffect:
				print("ability_effect", ability_effect)
			if ability_effect is PoisonEffect:
				var poison_effect_label = WEAPON_CARD_EFFECT.instance()
				poison_effect_label.set_text("attacks POISON enemies")
				effect_list.add_child(poison_effect_label)

func set_rarity(rarity: String) -> void:
	get_node("%Rarity").set_text(rarity)
	get_node("%Rarity").set("custom_colors/font_color", rarity_colors[rarity])

func set_colors(affinity: String) -> void:
	var active_affinity = card_colors[affinity]
	get_node("%Background").set_frame_color(active_affinity["background"])
	get_node("%Border").set_border_color(active_affinity["border"])
	get_node("%HeadingBackground").set_frame_color(active_affinity["heading_background"])
	get_node("%DetailsBackground").set_frame_color(active_affinity["details_background"])
