tool
extends NotionIntegration

export(bool) var import_weapons setget fetch_weapons

func _ready() -> void:
	DATABASE_ID = "17e5b08741fb4d1d95d321bb53770619"

func fetch_weapons(_value):
	make_request()

func _on_request_completed(_result, response_code, _headers, body) -> void:
	if response_code == HTTPClient.RESPONSE_OK:
		var json = JSON.parse(body.get_string_from_utf8())
		for weapon in json.result.results:
			if weapon.properties.name.title.size() > 0:
				var name = weapon.properties.name.title[0]["text"].content
				print(name)
				var type = weapon.properties.type.select.name
				print(type)
				var rarity = weapon.properties.rarity.select.name
				print(rarity)
				var affinity = weapon.properties.affinity.select.name
				print(affinity)
				print("----------")
