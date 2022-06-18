extends KinematicBody2D

class_name AbilityBase

onready var animatedSprite = $AnimatedSprite
onready var area2D = $Area2D

onready var FeedbackHandler = get_node('/root/FeedbackHandler')

var source_actor

var vector = Vector2()

var damaged_actors = []
var distance_from_player = 15
var attack_move_speed = 10
var damage = 1

var target_actor

func _ready() -> void:
	if source_actor == GameState.player:
		print("setCollideWithEnemies")
		setCollideWithEnemies()
	else:
		print("setCollideWithPlayer")
		setCollideWithPlayer()
	initialiseConfig()

func setCollideWithEnemies() -> void:
	set_collision_mask(4)
	set_collision_layer(4)

func setCollideWithPlayer() -> void:
	set_collision_mask(2)
	set_collision_layer(2)

func initialiseConfig() -> void:
	pass

func ensureTarget(current_target) -> bool:
	if target_actor and target_actor != current_target:
			return false
	return true

func damageOverlappingAreas() -> void:
	for area in area2D.get_overlapping_areas():
		var area_parent = area.get_parent()
		if (
			area_parent != source_actor
			and area.get_name() == 'HitBox'
			and not damaged_actors.has(area_parent.get_instance_id())
			and ensureTarget(area_parent)
		):
			damaged_actors.push_front(area_parent.get_instance_id())
			FeedbackHandler.shakeCamera()
			FeedbackHandler.lightVibrate()
			area_parent.damage(damage)
			if (
				(source_actor == GameState.player
				or source_actor == PossessionState.possessedNPC)
				and PlayerState.mana < PlayerState.max_mana
			):
				PlayerState.mana += 1
			area_parent.knockBack(
				source_actor.get_angle_to(area_parent.get_global_position()),
				200,
				20
			)
			collisionEffect(area_parent)

func collisionEffect(_target_actor) -> void:
	pass

func bang(attack_direction : Vector2, source) -> void:
	source_actor = source
	vector = attack_direction
	look_at(to_global(vector))
	animatedSprite.play()
	position = attack_direction.normalized() * distance_from_player

func _physics_process(_delta) -> void:
	if vector:
		vector = move_and_slide(vector.normalized() * attack_move_speed)
	if source_actor:
		damageOverlappingAreas()

func _on_AnimatedSprite_animation_finished():
	queue_free()
