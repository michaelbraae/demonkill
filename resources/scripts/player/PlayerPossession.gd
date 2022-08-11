extends PlayerAction

class_name PlayerPossession

var WHITE_IMPACT = preload('res://resources/effects/impacts/white_impact/WhiteImpact.tscn')
var POSSESSION_VFX_SCENE = preload("res://scenes/vfx/possession_vfx/PossessionVFX.tscn")

onready var POSSESSION_ARROW_SCENE = preload("res://scenes/ui/possession_arrow/PossessionArrow.tscn")
var possession_arrow_instance

var possession_targeting_started: bool = false
var possession_targets_to_ignore: Array = []

func possession_cast_begun() -> void:
	possession_targets_to_ignore = []
	if not possession_targeting_started and dash_available and PlayerState.mana >= 1:
		possession_arrow_instance = POSSESSION_ARROW_SCENE.instance()
		add_child(possession_arrow_instance)
		possession_targeting_started = true
		state = POSSESSION_TARGETING
		Engine.time_scale = 0.3

func possession_cast_ended() -> void:
#	if dash_available and possession_targeting_started:
	if  possession_targeting_started:
		movement_ability()
		possession_dash_vector = getAttackDirection()
		state = POSSESSION_DASH
		if is_instance_valid(possession_arrow_instance):
			possession_arrow_instance.queue_free()
			possession_arrow_instance = null
		possession_targeting_started = false
		Engine.time_scale = 1

func _physics_process(_delta):
	if state == POSSESSION_DASH:
		var overlapping_areas = $PossessionHitBox.get_overlapping_areas()
		for area in overlapping_areas:
			if area.get_name() == "EnemyPossessionHitBox" and not possession_targets_to_ignore.has(area.get_parent()):
				var impact_instance = WHITE_IMPACT.instance()
				get_tree().get_root().add_child(impact_instance)
				impact_instance.position = area.get_parent().get_global_position()
				impact_instance.play()
				PossessionState.possessEntity(area.get_parent())
				var possession_vfx = POSSESSION_VFX_SCENE.instance()
				area.get_parent().add_child(possession_vfx)
				possession_vfx.play()
				PlayerState.useMana(2)
				PlayerState.addHealth(2)
				break

func handlePlayerAction() -> void:
	if state == POSSESSION_TARGETING:
		possession_targets_to_ignore = []
		animatedSprite.play(getAnimation())
	else:
		.handlePlayerAction()
