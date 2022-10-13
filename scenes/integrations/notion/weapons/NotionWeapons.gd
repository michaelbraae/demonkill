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
		for weapon_json in json.result.results:
			if weapon_json.properties.name.title.size() > 0:
				save_weapon(weapon_json)
		if weapon_created_count > 0:
			print(str(weapon_created_count, " Weapons Successfully Created"))
			weapon_created_count = 0

func get_icon_url(weapon_json) -> String:
	if weapon_json.properties.icon.files.size() > 0:
		return weapon_json.properties.icon.files[0].file.url
	return ""

func save_weapon(weapon_json) -> void:
	if !weapon_json.properties.import.checkbox:
		return
	var new_weapon = WEAPON_SCENE.instance()
	
	var weapon_name =  weapon_json.properties.name.title[0]["text"].content
	new_weapon.weapon_name = weapon_name
	weapon_name = weapon_name.replace(" ", "")
	
	new_weapon.archetype = weapon_json.properties.type.select.name.to_upper()
	new_weapon.rarity = weapon_json.properties.rarity.select.name.to_upper()
	new_weapon.affinity = weapon_json.properties.affinity.select.name.to_upper()
	new_weapon.combo_finish_index = int(weapon_json.properties.combo_finish_index.number)
	new_weapon.attack_speed = float(weapon_json.properties.attack_speed.number)
	
	var icon_url = get_icon_url(weapon_json)

	if icon_url != "":
#		new_weapon.weapon_icon = download_texture(icon_url, str(name, ".png"))
		var icon_texture = download_texture(icon_url, str(weapon_name, ".png"))
#		yield(self, "image_download_finished")
#		new_weapon.weapon_icon = icon_texture

	var scene = PackedScene.new()
	var scene_name = str(weapon_name, ".tscn")
	
	scene.set_name(str(weapon_name, "Pickup"))
	
	var result = scene.pack(new_weapon)
	if result == OK:
		var save_result = ResourceSaver.save(str("res://test/weapons/", scene_name), scene)
		if save_result == OK:
			weapon_created_count += 1
			save_weapon_pickup(weapon_name, scene)
		else:
			push_error(str("An error has occured while attempting to save weapon to disk. Weapon Name: ", name))

func save_weapon_pickup(weapon_name: String, weapon: PackedScene) -> void:
	var pickup_scene = WEAPON_PICKUP_SCENE.instance()
	pickup_scene.weapon = weapon
	
	pickup_scene.set_name(str(weapon_name, "Pickup"))
	
	print("weapon_name: ", weapon_name)
	print("weapon: ", weapon)

	var scene = PackedScene.new()
	var scene_name = str(weapon_name, "Pickup.tscn")
	
	var result = scene.pack(pickup_scene)
	if result == OK:
		var save_result = ResourceSaver.save(str("res://test/weapon_pickups/", scene_name), scene)
		if save_result != OK:
			push_error(str("An error has occured while attempting to save weapon to disk. Weapon Name: ", weapon.weapon_name))
		
