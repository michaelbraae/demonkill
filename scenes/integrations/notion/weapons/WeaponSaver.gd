extends Node

class_name WeaponSaver

signal image_download_finished

var WEAPON_SCENE = preload("res://scenes/weapon/Weapon.tscn")
var WEAPON_PICKUP_SCENE = preload("res://scenes/weapon/weapon_pickup/WeaponPickup.tscn")

var icon_texture

func get_icon_url(weapon_json) -> String:
	if weapon_json.properties.icon.files.size() > 0:
		return weapon_json.properties.icon.files[0].file.url
	return ""

func save_weapon(weapon_json, integration: NotionIntegration) -> void:
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
		download_texture(icon_url, str(weapon_name, ".png"))
		yield(self, "image_download_finished")
		print('image finished, setting params..')
		new_weapon.weapon_icon = icon_texture

	var scene = PackedScene.new()
	var scene_name = str(weapon_name, ".tscn")
	
	scene.set_name(str(weapon_name, "Pickup"))
	
	var result = scene.pack(new_weapon)
	if result == OK:
		var save_result = ResourceSaver.save(str("res://test/weapons/", scene_name), scene)
		if save_result == OK:
			save_weapon_pickup(weapon_name, scene)
		else:
			push_error(str("An error has occured while attempting to save weapon to disk. Weapon Name: ", name))

func save_weapon_pickup(weapon_name: String, weapon: PackedScene) -> void:
	var pickup_scene = WEAPON_PICKUP_SCENE.instance()
	pickup_scene.weapon = weapon
	
	pickup_scene.set_name(str(weapon_name, "Pickup"))
	
	var scene = PackedScene.new()
	var scene_name = str(weapon_name, "Pickup.tscn")
	
	var result = scene.pack(pickup_scene)
	if result == OK:
		var save_result = ResourceSaver.save(str("res://test/weapon_pickups/", scene_name), scene)
		if save_result != OK:
			push_error(str("An error has occured while attempting to save weapon to disk. Weapon Name: ", weapon.weapon_name))




func download_texture(url : String, file_name : String) -> void:
	file_name = file_name.replace(" ", "")
	var http = HTTPRequest.new()
	add_child(http)
	
	var icon_path = str("res://test/images/", file_name)
	http.set_download_file(icon_path)
	http.request(url)
	
	print("downloading image..")
	
	yield(http, "request_completed")
	
#	var texture = Texture.new()
#	var image = Image.new()
	
	icon_texture = ResourceLoader.load(icon_path)
	print(icon_texture)
	
	print("download complete.. icon_path: ", icon_path)
	
	emit_signal("image_download_finished")
#	image.load(icon_path)
#	texture.create_from_image(image)
#	return texture
