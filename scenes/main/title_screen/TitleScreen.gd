extends Control

# warning-ignore-all:return_value_discarded

func _ready() -> void:
	PlayerState.weapon_slot_1 = null
	PlayerState.weapon_slot_2 = null
	$CenterContainer/VBoxContainer/PlayButton.connect("pressed", self, "play_button_pressed")
	$CenterContainer/VBoxContainer/DungeonButton.connect("pressed", self, "on_dungeon_button_pressed")
	$CenterContainer/VBoxContainer/QuitButton.connect("pressed", self, "on_quit_button_pressed")
	GameState.state = GameState.MAIN_MENU

func play_button_pressed():
	AudioManager.play_audio(AudioManager.UI_ACCEPT)
	LevelManager.goto_scene('res://scenes/levels/Town.tscn')

func on_dungeon_button_pressed() -> void:
	AudioManager.play_audio(AudioManager.UI_ACCEPT)
	LevelManager.goto_scene('res://scenes/dungeon_generator/DungeonGenerator.tscn')

func on_quit_button_pressed() -> void:
	get_tree().quit()
