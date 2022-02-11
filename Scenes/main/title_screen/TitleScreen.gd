extends Control

func _ready():
	GameState.state = GameState.MAIN_MENU

func _on_new_Game_button_pressed():
	LevelManager.goto_scene('res://scenes/levels/Town.tscn')
