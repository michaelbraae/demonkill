extends Control

var weapon: Weapon

export var strength_background: Color = Color(0.17, 0.17, 0.17)
export var strength_border: Color = Color(0.78, 0.208, 0.345)
export var strength_heading_background: Color = Color(0.275, 0.184, 0.204)
export var strength_details_background: Color = Color(0.518, 0.039, 0.157)

export var intelligence_background: Color = Color(0.02, 0.1, 0.13)
export var intelligence_border: Color = Color(0, 0.76, 1)
export var intelligence_heading_background: Color = Color(0.02, 0.1, 0.13)
export var intelligence_details_background: Color = Color(0.03, 0.44, 0.56)

export var vitality_background: Color = Color(0.004, 0.11, 0.09)
export var vitality_border: Color = Color(0.024, 0.851, 0.455)
export var vitality_heading_background: Color = Color(0.004, 0.11, 0.09)
export var vitality_details_background: Color = Color(0, 0.576, 0.435)

var card_colors: Dictionary = {
	"STRENGTH": {
		"background": strength_background,
		"border": strength_border,
		"heading_background": strength_heading_background,
		"details_background": strength_details_background,
	},
	"INTELLIGENCE": {
		"background": intelligence_background,
		"border": intelligence_border,
		"heading_background": intelligence_heading_background,
		"details_background": intelligence_details_background,
	},
	"VITALITY": {
		"background": vitality_background,
		"border": vitality_border,
		"heading_background": vitality_heading_background,
		"details_background": vitality_details_background,
	}
}

export var exotic_color: Color = Color(1, 0.761, 0.149)
export var legendary_color: Color = Color(0.561, 0, 1)
export var rare_color: Color = Color(0.157, 1, 0.949)
export var common_color: Color = Color(0.824, 0.824, 0.824)

var rarity_colors: Dictionary = {
	"EXOTIC": exotic_color,
	"LEGENDARY": legendary_color,
	"RARE": rare_color,
	"COMMON": common_color
}

func set_params() -> void:
	get_node("%Name").set_text(weapon.weapon_name)
	set_rarity(weapon.rarity)
	set_colors(weapon.affinity)
	get_node("%Icon").set_texture(weapon.weapon_icon)

func set_rarity(rarity: String) -> void:
	get_node("%Rarity").set_text(rarity)
	get_node("%Rarity").set("custom_colors/font_color", rarity_colors[rarity])

func set_colors(affinity: String) -> void:
	var active_affinity = card_colors[affinity]
	get_node("%Background").set_frame_color(active_affinity["background"])
	get_node("%Border").set_border_color(active_affinity["border"])
	get_node("%HeadingBackground").set_frame_color(active_affinity["heading_background"])
	get_node("%DetailsBackground").set_frame_color(active_affinity["details_background"])
