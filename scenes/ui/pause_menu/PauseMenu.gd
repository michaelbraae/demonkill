extends Control

onready var ResumeButton = $CenterContainer/VBoxContainer/ResumeButton
onready var QuitButton = $CenterContainer/VBoxContainer/QuitButton
onready var MainMenuButton = $CenterContainer/VBoxContainer/MainMenuButton

var is_paused: bool = false setget set_is_paused

func _ready() -> void:
	ResumeButton.connect("pressed", self, "on_resume_pressed")
	MainMenuButton.connect("pressed", self, "on_main_menu_pressed")
	QuitButton.connect("pressed", self, "on_quit_pressed")

func pause() -> void:
	self.is_paused = true

func resume() -> void:
	self.is_paused = false

func set_is_paused(value: bool) -> void:
	is_paused = value
	GameState.is_paused = value
	get_tree().paused = value
	visible = value

func on_resume_pressed() -> void:
	resume()

func on_main_menu_pressed() -> void:
	resume()
	LevelManager.goto_scene("res://scenes/main/title_screen/TitleScreen.tscn")

func on_quit_pressed() -> void:
	get_tree().quit()
