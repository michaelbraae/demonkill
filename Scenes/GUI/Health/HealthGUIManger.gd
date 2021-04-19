extends CanvasLayer

onready var GameState = get_node('/root/GameState')
onready var PlayerState = get_node('/root/PlayerState')
onready var PossessionState = get_node('/root/PossessionState')

onready var label = get_node('Label')

var health_current
var max_health

func _process(_delta):
	if GameState.state == GameState.CONTROLLING_NPC:
		health_current = PossessionState.possessedNPC.health
		max_health = PossessionState.possessedNPC.max_health
	else:
		health_current = PlayerState.health
		max_health = PlayerState.max_health
	label.set_text(str(health_current, '/', max_health))
