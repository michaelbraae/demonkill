extends CombatReadyAI

class_name PossessableAI

onready var POSSESSION_ARROW_SCENE = preload("res://scenes/ui/possession_arrow/PossessionArrow.tscn")

var possession_arrow_instance
var possession_targeting_started: bool = false

func possession_cast_begun() -> void:
	if isPossessed() and PlayerState.mana >= 1:
		state = POSSESSION_TARGETING
		Engine.time_scale = 0.3

func possession_cast_ended() -> void:
	if isPossessed():
		PossessionState.exitPossession(position)
		if is_instance_valid(possession_arrow_instance):
			possession_arrow_instance.queue_free()
		Engine.time_scale = 1

func handlePossessionExit() -> void:
	onPossessEnd()
	get_node("CollisionShape2D").disabled = true
	state = POSSESSION_RECOVERY
