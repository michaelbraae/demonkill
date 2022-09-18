extends Control

onready var ResumeButton = $CenterContainer/VBoxContainer/ResumeButton
onready var QuitButton = $CenterContainer/VBoxContainer/QuitButton
onready var MainMenuButton = $CenterContainer/VBoxContainer/MainMenuButton

var is_paused: bool = false setget set_is_paused

func _ready() -> void:
	ResumeButton.connect("pressed", self, "on_resume_pressed")
	MainMenuButton.connect("pressed", self, "on_main_menu_pressed")
	QuitButton.connect("pressed", self, "on_quit_pressed")

func on_interacted_pressed() -> void:
	pass

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

func add_weapon_icon_to_ui_slot(weapon_icon, slot: int) -> void:
	match slot:
		1: get_node("%Slot1Icon").texture = weapon_icon
		2: get_node("%Slot2Icon").texture = weapon_icon

func clear_icon_from_slot(slot: int) -> void:
	print("PauseMenu: clear_icon_from_slot(): ", slot)
	match slot:
		1: get_node("%Slot1Icon").set_texture(null)
		2: get_node("%Slot2Icon").set_texture(null)

func connect_to_signals() -> void:
	InputEmitter.connect("interacted", self, "interacted")

func disconnect_from_signals() -> void:
	if InputEmitter.is_connected("interacted", self, "interacted"):
		InputEmitter.disconnect("interacted", self, "interacted")

func interacted() -> void:
	GameState.player.swap_weapons_between_slots()
