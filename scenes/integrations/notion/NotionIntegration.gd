tool
extends Node2D

class_name NotionIntegration

signal image_download_finished

const API_URL: String = "https://api.notion.com/v1/databases/"
const URL_SUFFIX: String = "/query"
const NOTION_API_KEY: String = "secret_vDZADBQjyyhAvo72UDzPHZuYsZLBR7i5RBsfZlY6ERP"
const NOTION_VERSION: String = "2022-02-22"

var DATABASE_ID: String = "17e5b08741fb4d1d95d321bb53770619"
var query: String = ""

func make_request() -> void:
	if !$HTTPRequest.is_connected("request_completed", self, "_on_request_completed"):
		$HTTPRequest.connect("request_completed", self, "_on_request_completed")
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

func download_texture(url : String, file_name : String) -> ImageTexture:
	file_name = file_name.replace(" ", "")
	var http = HTTPRequest.new()
	add_child(http)
	
	var icon_path = str("res://test/images/", file_name)
	http.set_download_file(icon_path)
	http.request(url)
	
	print("downloading image..")
	
	yield(http, "request_completed")
	
	var texture = ImageTexture.new()
	var image = Image.new()
	
	print("download complete.. icon_path: ", icon_path)
	
	emit_signal("image_download_finished")
	image.load(icon_path)
	texture.create_from_image(image)
	return texture
