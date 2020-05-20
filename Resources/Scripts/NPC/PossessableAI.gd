extends PathfindingAI

class_name PossessableAI

var interactable
var possessable 

func setInteractable(interactable_value : bool) -> void:
	interactable = interactable_value

func getInteractable() -> bool:
	return interactable

func setPossessable(possessable_value : bool) -> void:
	possessable = possessable_value

func getPossessable() -> bool:
	return possessable

# when possesed the players inputs are applied to the possesed AI
