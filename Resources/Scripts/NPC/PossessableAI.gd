extends PathfindingAI

class_name PossessableAI

var interactable = false
var possessable = false 

func setInteractable(interactable_value : bool) -> void:
	interactable = interactable_value

func getInteractable() -> bool:
	return interactable

func setPossessable(possessable_value : bool) -> void:
	possessable = possessable_value

func getPossessable() -> bool:
	return possessable
