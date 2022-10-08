tool
extends Node2D

class_name NotionIntegration

const API_URL: String = "https://api.notion.com/v1/databases/"
const URL_SUFFIX: String = "/query"
const NOTION_API_KEY: String = "secret_vDZADBQjyyhAvo72UDzPHZuYsZLBR7i5RBsfZlY6ERP"
var DATABASE_ID: String = "17e5b08741fb4d1d95d321bb53770619"
const NOTION_VERSION: String = "2022-02-22"
var query: String = ""

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func make_request() -> void:
	var headers = [
		str("Authorization: ", NOTION_API_KEY),
		str("Notion-Version: ", NOTION_VERSION),
		"Content-Type: application/json"
	]
	
	
	$HTTPRequest.request(
		str(API_URL, DATABASE_ID, URL_SUFFIX),
		headers,
		false,
		HTTPClient.METHOD_POST,
		query
	)

func _on_request_completed(_result, response_code, _headers, body) -> void:
	pass
