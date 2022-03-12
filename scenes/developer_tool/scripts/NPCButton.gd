extends Node

class_name NPCButton

var SCENE = "";

func getSceneString() -> Dictionary:
	return {
		"scene": SCENE,
		"count": $SpinBox.value
	}
