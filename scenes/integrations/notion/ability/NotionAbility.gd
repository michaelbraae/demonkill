tool
extends NotionIntegration

signal ability_saved

export(bool) var import_abilities setget fetch_all_abilities

var weapon_created_count: int = 0

func _ready() -> void:
	DATABASE_ID = "922288d1f46d4c3da5971901bf12462c"

func fetch_all_abilities(value):
	if value:
		var dir = Directory.new()
		dir.open("res://test/")
		dir.make_dir("abilities")
		make_request()

func _on_request_completed(_result, response_code, _headers, body) -> void:
	if response_code == HTTPClient.RESPONSE_OK:
		var json = JSON.parse(body.get_string_from_utf8())
		for ability_json in json.result.results:
			var ability_saver = AbilitySaver.new()
			add_child(ability_saver)
			ability_saver.save_ability(ability_json)
			emit_signal("ability_saved")
