extends PlayerAction

class_name PlayerPossession

onready var POSSESSION_ARROW_SCENE = preload("res://scenes/ui/possession_arrow/PossessionArrow.tscn")
var possession_arrow_instance

var possession_targeting_started: bool = false

func _process(_delta):
	if Input.is_action_just_pressed("possess"):
		if not possession_targeting_started:
			possession_arrow_instance = POSSESSION_ARROW_SCENE.instance()
			add_child(possession_arrow_instance)
			possession_targeting_started = true
			state = POSSESSION_TARGETING
			Engine.time_scale = 0.3
	if Input.is_action_pressed("possess"):
		pass
#		if is_instance_valid(possession_arrow_instance):
#			var point = position
#			possession_arrow_instance.position = point + (possession_arrow_instance.position - point).rotated(getAttackDirection().angle())
#			possession_arrow_instance.set_rotation(getAttackDirection().angle())
	elif Input.is_action_just_released("possess"):
		state = POSSESSION_DASH
		if is_instance_valid(possession_arrow_instance):
			possession_arrow_instance.queue_free()
			possession_arrow_instance = null
		possession_targeting_started = false
		Engine.time_scale = 1

func handlePlayerAction() -> void:
	if state == POSSESSION_TARGETING:
		animatedSprite.play(getAnimation())
	else:
		.handlePlayerAction()
