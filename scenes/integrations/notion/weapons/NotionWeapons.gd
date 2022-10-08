tool
extends Node2D

export(bool) var import_weapons setget fetch_weapons


const API_URL: String = "https://api.notion.com/v1/databases/"
const URL_SUFFIX: String = "/query"
const NOTION_API_KEY: String = "secret_vDZADBQjyyhAvo72UDzPHZuYsZLBR7i5RBsfZlY6ERP"
const WEAPON_DATABASE_ID: String = "17e5b08741fb4d1d95d321bb53770619"
const NOTION_VERSION: String = "2022-02-22"

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func fetch_weapons(_value):
	var headers = [
		str("Authorization: ", NOTION_API_KEY),
		str("Notion-Version: ", NOTION_VERSION),
		"Content-Type: application/json"
	]

	var query = ""
	
	$HTTPRequest.request(
		str(API_URL, WEAPON_DATABASE_ID, URL_SUFFIX),
		headers,
		false,
		HTTPClient.METHOD_POST,
		query
	)

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
