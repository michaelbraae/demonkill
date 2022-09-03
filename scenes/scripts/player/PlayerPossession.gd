extends PlayerAnimation

class_name PlayerPossession

var POSSESSION_VFX_SCENE = preload("res://scenes/vfx/possession_vfx/PossessionVFX.tscn")

onready var POSSESSION_ARROW_SCENE = preload("res://scenes/ui/possession_arrow/PossessionArrow.tscn")

export var possession_duration: float = 5.0
export var possession_dash_cooldown: float = 2.0

var possession_arrow_instance

var possession_targeting_started: bool = false
var possession_targets_to_ignore: Array = []

var possession_dash_timer
var possession_dash_cooldown_timer
var possession_dash_started = false

func _ready() -> void:
	InputHandler.setMouseMode()
	possession_dash_timer = Timer.new()
	possession_dash_timer.one_shot = true
	possession_dash_timer.connect('timeout', self, 'possession_dash_timeout')
	add_child(possession_dash_timer)
	possession_dash_cooldown_timer = Timer.new()
	possession_dash_cooldown_timer.one_shot = true
	# warning-ignore:return_value_discarded
	$PossessionHitBox.connect("area_entered", self, "possession_hitbox_entered")
	# possession_dash_cooldown_timer.connect('timeout', self, 'dash_cooldown_timeout')
	add_child(possession_dash_cooldown_timer)

func possession_hitbox_entered(area) -> void:
	if state == POSSESSION_DASH and area.get_name() == "EnemyPossessionHitBox" and not possession_targets_to_ignore.has(area.get_parent()):
		PossessionState.possessEntity(area.get_parent())
		var possession_vfx = POSSESSION_VFX_SCENE.instance()
		area.get_parent().add_child(possession_vfx)
		possession_vfx.play()
		PlayerState.useMana(2)
		PlayerState.addHealth(2)
	

func possession_dash_timeout() -> void:
	set_collision_layer_bit(1, true)
	set_collision_mask_bit(1, true)
	possession_dash_started = false
	possession_dash_vector = Vector2()
	state = DASH_RECOVERY

func possession_cast_begun() -> void:
	possession_targets_to_ignore = []
	if not possession_targeting_started and possession_dash_cooldown_timer.is_stopped() and PlayerState.mana >= 1:
		possession_arrow_instance = POSSESSION_ARROW_SCENE.instance()
		add_child(possession_arrow_instance)
		possession_targeting_started = true
		state = POSSESSION_TARGETING
		Engine.time_scale = 0.3

func possession_cast_ended() -> void:
	if possession_dash_cooldown_timer.is_stopped() and possession_targeting_started:
#	if possession_targeting_started:
		initiate_possession_dash()
		possession_dash_vector = getAttackDirection()
		state = POSSESSION_DASH
		if is_instance_valid(possession_arrow_instance):
			possession_arrow_instance.queue_free()
			possession_arrow_instance = null
		possession_targeting_started = false
		Engine.time_scale = 1

func handlePlayerAction() -> void:
	if state == POSSESSION_TARGETING:
		possession_targets_to_ignore = []
		animatedSprite.play(getAnimation())
	else:
		.handlePlayerAction()

func initiate_possession_dash() -> void:
	if dash_available:
		print("initiate possession dash")
		FeedbackHandler.shake_camera(0.2, 0.8)
		set_collision_layer_bit(1, false)
		set_collision_mask_bit(1, false)
		state = DASH
		possession_dash_cooldown_timer.start(possession_dash_cooldown)
		possession_dash_timer.start(dash_duration)
		possession_dash_vector = InputHandler.getMovementVector()

func continue_possession_dash() -> void:
	on_dash_continuous()
	if not possession_dash_started:
		possession_dash_started = true
		if state == POSSESSION_DASH:
			dash_vector = possession_dash_vector
		elif not velocity:
			dash_vector = getVectorFromFacingDirection()
		velocity = dash_vector * 450
