extends CombatReadyAI

class_name PossessableAI

onready var POSSESSION_ARROW_SCENE = preload("res://scenes/ui/possession_arrow/PossessionArrow.tscn")

# Once the health gets below this percentage, possession is possible
export var possession_guard_threshold: float = -1.0

var possession_arrow_instance
var possession_targeting_started: bool = false

func _ready() -> void:
	if possession_guard_threshold > 0.0:
		$PossessionGuard.visible = true
		connect("damaged", self, "on_damaged")

func on_damaged(new_health) -> void:
	var health_guard_threshold = max_health * (possession_guard_threshold / 100)
	if new_health > 0:
		if new_health < health_guard_threshold:
			$PossessionGuard.visible = false

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
