extends "res://Resources/Scripts/NPC/PathfindingAI.gd"

var interactable = false
var possessable = false 

func setInteractable(interactable_value : bool) -> void:
	interactable = interactable_value

func setPossessable(possessable_value : bool) -> void:
	possessable = possessable_value
