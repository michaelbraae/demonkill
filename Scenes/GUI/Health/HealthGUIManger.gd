extends CanvasLayer

onready var GameState = get_node("/root/GameState")
onready var PossessionState = get_node("/root/PossessionState")

onready var label = get_node("Label")

var health_current
var health_max

func _ready():
	if GameState.state == GameState.CONTROLLING_NPC:
		health_current = PossessionState.possessedNPC.health
		health_max = PossessionState.possessedNPC.HEALTH_MAX
		label.set_text(health_current + '/' + health_max)
