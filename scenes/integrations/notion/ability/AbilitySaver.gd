extends Node

class_name AbilitySaver

const PREFAB_BASE_PATH: String = "res://scenes/integrations/notion/ability/prefabs/"

func fetch_page(id: String) -> void:
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "_fetch_page_complete")
	var headers = [
		str("Authorization: ", NotionContants.NOTION_API_KEY),
		str("Notion-Version: ", NotionContants.NOTION_VERSION),
		"Content-Type: application/json"
	]
	
	http.request(
		str("https://api.notion.com/v1/pages/", id),
		headers,
		false,
		HTTPClient.METHOD_GET
	)

func _fetch_page_complete(_result, response_code, _headers, body) -> void:
	pass

func save_ability(ability_json) -> PackedScene:
	
	
	var weapon_type = ability_json.properties.weapon_type.select.name
	weapon_type = weapon_type[0].to_upper() + weapon_type.substr(1,-1)
	var scene_path = get_ability_scene_path(weapon_type)

	# if the ability already exists with that name, just fetch it
	
	var ability_instance = load(scene_path)

	ability_instance = ability_instance.instance()

	var ability_name = ability_json.properties.name.title[0]["text"].content
	ability_instance.set_name(ability_name)

	print(scene_path)
	print(ability_instance)

	var scene = PackedScene.new()
	var scene_name = str(ability_name, ".tscn")
	
	var result = scene.pack(ability_instance)
	if result == OK:
		ResourceSaver.save(str("res://test/abilities/", scene_name), scene)
	
	return scene

func get_ability_scene_path(ability_type: String) -> String:
	return str(PREFAB_BASE_PATH, ability_type, "/", ability_type, "Ability.tscn")
