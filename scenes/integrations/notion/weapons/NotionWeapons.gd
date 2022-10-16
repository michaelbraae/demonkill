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
				var weapon_saver = WeaponSaver.new()
				add_child(weapon_saver)
				weapon_saver.save_weapon(weapon_json, self)
		if weapon_created_count > 0:
			print(str(weapon_created_count, " Weapons Successfully Created"))
			weapon_created_count = 0

