extends Control

func _ready():
	$CenterContainer/VBoxContainer/DungeonButton.connect("pressed", self, "on_dungeon_button_pressed")
	$CenterContainer/VBoxContainer/QuitButton.connect("pressed", self, "on_quit_button_pressed")
		
	GameState.state = GameState.MAIN_MENU

func _on_new_Game_button_pressed():
	LevelManager.goto_scene('res://scenes/levels/Town.tscn')

func on_dungeon_button_pressed() -> void:
	LevelManager.goto_scene('res://scenes/dungeon_generator/DungeonGenerator.tscn')

func on_quit_button_pressed() -> void:
	get_tree().quit()
