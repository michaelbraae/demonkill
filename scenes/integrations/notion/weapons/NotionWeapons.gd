tool
extends NotionIntegration

var WEAPON_SCENE = preload("res://scenes/weapon/Weapon.tscn")
var WEAPON_PICKUP_SCENE = preload("res://scenes/weapon/weapon_pickup/WeaponPickup.tscn")

export(bool) var import_weapons setget fetch_weapons

var weapon_created_count: int = 0

func _ready() -> void:
	DATABASE_ID = "17e5b08741fb4d1d95d321bb53770619"

func fetch_weapons(value):
	if value:
		var dir = Directory.new()
		dir.open("res://test/")
		dir.make_dir("weapons")
		dir.make_dir("weapon_pickups")
		dir.make_dir("images")
		make_request()

func _on_request_completed(_result, response_code, _headers, body) -> void:
	if response_code == HTTPClient.RESPONSE_OK:
		var json = JSON.parse(body.get_string_from_utf8())
		for weapon in json.result.results:
			if weapon.properties.name.title.size() > 0:
				var name = weapon.properties.name.title[0]["text"].content
				var archetype = weapon.properties.type.select.name
				var rarity = weapon.properties.rarity.select.name
				var affinity = weapon.properties.affinity.select.name
				var icon_url = get_icon_url(weapon)
				save_weapon(name, archetype, affinity, rarity, icon_url)
		if weapon_created_count > 0:
			print(str(weapon_created_count, " Weapons Successfully Created"))
			weapon_created_count = 0

func get_icon_url(weapon_json) -> String:
	if weapon_json.properties.icon.files.size() > 0:
		return weapon_json.properties.icon.files[0].file.url
	return ""

func save_weapon(name: String, archetype: String, affinity: String, rarity: String, icon_url: String = "") -> void:
	var new_weapon = WEAPON_SCENE.instance()
	new_weapon.weapon_name = name
	new_weapon.archetype = archetype.to_upper()
	new_weapon.rarity = rarity.to_upper()
	new_weapon.affinity = affinity.to_upper()

#	if icon_url != "":
#		new_weapon.weapon_icon = download_texture(icon_url, str(name, ".png"))
#		var icon_texture = download_texture(icon_url, str(name, ".png"))
#		yield(self, "image_download_finished")
#		new_weapon.weapon_icon = icon_texture

	var scene = PackedScene.new()
	var scene_name = str(name.replace(" ", ""), ".tscn")
	
	var result = scene.pack(new_weapon)
	if result == OK:
		var save_result = ResourceSaver.save(str("res://test/weapons/", scene_name), scene)
		if save_result == OK:
			weapon_created_count += 1
			save_weapon_pickup(new_weapon)
		else:
			push_error(str("An error has occured while attempting to save weapon to disk. Weapon Name: ", name))

func save_weapon_pickup(weapon: Weapon) -> void:
	if is_instance_valid(weapon) and weapon.weapon_name:
		var pickup_scene = WEAPON_PICKUP_SCENE.instance()
		pickup_scene.weapon = weapon
		
		var scene = PackedScene.new()
		var scene_name = str(weapon.weapon_name.replace(" ", ""), "Pickup.tscn")
		
		var result = scene.pack(pickup_scene)
		if result == OK:
			var save_result = ResourceSaver.save(str("res://test/weapon_pickups/", scene_name), scene)
			if save_result != OK:
				push_error(str("An error has occured while attempting to save weapon to disk. Weapon Name: ", weapon.weapon_name))
			
