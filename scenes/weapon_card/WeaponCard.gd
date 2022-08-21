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
	if weapon:
		get_node("%Name").set_text(weapon.weapon_name)
		get_node("%Icon").set_texture(weapon.weapon_icon)
		get_node("%AttackSpeedLabel").set_text(str(weapon.attack_speed) + " attack speed")
		set_rarity(weapon.rarity)
		set_colors(weapon.affinity)
		set_effect_labels()
		weapon.queue_free()

func set_rarity(rarity: String) -> void:
	get_node("%Rarity").set_text(rarity)
	get_node("%Rarity").set("custom_colors/font_color", rarity_colors[rarity])

func set_colors(affinity: String) -> void:
	var active_affinity = card_colors[affinity]
	get_node("%Background").set_frame_color(active_affinity["background"])
	get_node("%Border").set_border_color(active_affinity["border"])
	get_node("%HeadingBackground").set_frame_color(active_affinity["heading_background"])
	get_node("%DetailsBackground").set_frame_color(active_affinity["details_background"])

func set_effect_labels() -> void:
	for ability in weapon.attack_abilities:
		var ability_instance = ability.instance()
		for ability_effect in ability_instance.get_node("Effects").get_children():
			if ability_effect is DamageEffect:
				set_damage_label(ability_effect.damage)
				set_bonus_damage_label()
			if ability_effect is HealEffect:
				print("ability_effect", ability_effect)
			if ability_effect is PoisonEffect:
				set_poison_label()
			if ability_effect is BurnEffect:
				set_burn_label()
			if ability_effect is FreezeEffect:
				set_freeze_label()

func set_damage_label(damage: int) -> void:
	get_node("%DPSLabel").set_text(str(damage * weapon.attack_speed) + " DPS")

func set_bonus_damage_label() -> void:
	## calculate bonus damage by multtplying player affinity in correct column by 5 or 10?
	var bonus_damage_multiplier: int = 0
	match weapon.affinity:
		"STRENGTH":
			bonus_damage_multiplier = PlayerState.strength_affinity
		"INTELLIGENCE":
			bonus_damage_multiplier = PlayerState.intelligence_affinity
		"VITALITY":
			bonus_damage_multiplier = PlayerState.vitality_affinity
	if bonus_damage_multiplier:
		get_node("%BonusDamageLabel").set_text("+" + str(bonus_damage_multiplier * 10) + "% Damage")

func set_poison_label() -> void:
	var poison_effect_label = WEAPON_CARD_EFFECT.instance()
	poison_effect_label.set_text("Attacks POISON enemies")
	effect_list.add_child(poison_effect_label)

func set_burn_label() -> void:
	var burn_effect_label = WEAPON_CARD_EFFECT.instance()
	burn_effect_label.set_text("Attacks BURN enemies")
	effect_list.add_child(burn_effect_label)

func set_freeze_label() -> void:
	var burn_effect_label = WEAPON_CARD_EFFECT.instance()
	burn_effect_label.set_text("Attacks FREEZE enemies")
	effect_list.add_child(burn_effect_label)
