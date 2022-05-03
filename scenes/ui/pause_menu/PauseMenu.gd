extends Control

onready var ResumeButton = $CenterContainer/VBoxContainer/ResumeButton
onready var QuitButton = $CenterContainer/VBoxContainer/QuitButton

var is_paused: bool = false setget set_is_paused

func _ready() -> void:
	ResumeButton.connect("pressed", self, "on_resume_pressed")
	QuitButton.connect("pressed", self, "on_quit_pressed")

func set_is_paused(value: bool) -> void:
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _unhandled_input(event) -> void:
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func on_resume_pressed() -> void:
	self.is_paused = false

func on_quit_pressed() -> void:
	get_tree().quit()

