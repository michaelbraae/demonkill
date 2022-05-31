extends CombatReadyAI

class_name PossessableAI

onready var POSSESSION_ARROW_SCENE = preload("res://scenes/ui/possession_arrow/PossessionArrow.tscn")

var possession_arrow_instance
var possession_targeting_started: bool = false

func _process(_delta):
	if Input.is_action_just_pressed("possess") and isPossessed() and PlayerState.mana >= 1:
		PlayerState.useMana(1)
		possession_arrow_instance = POSSESSION_ARROW_SCENE.instance()
		add_child(possession_arrow_instance)
		possession_targeting_started = true
		state = POSSESSION_TARGETING
		Engine.time_scale = 0.3
	elif Input.is_action_just_released("possess") and isPossessed():
		PossessionState.exitPossession(position)
		if is_instance_valid(possession_arrow_instance):
			possession_arrow_instance.queue_free()
		Engine.time_scale = 1

func handlePossessionExit() -> void:
	onPossessEnd()
	get_node("CollisionShape2D").disabled = true
	state = POSSESSION_RECOVERY
