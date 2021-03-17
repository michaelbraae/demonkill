extends Control

onready var GameState = get_node("/root/GameState")

func _ready():
	GameState.state = GameState.MAIN_MENU

func _on_new_Game_button_pressed():
	LevelManager.goto_scene("res://Scenes/Levels/Town/Town.tscn")
