extends KinematicBody2D

class_name Ability

# warning-ignore-all:return_value_discarded

var source_actor: KinematicBody2D

var target_actor: KinematicBody2D

var target_vector: Vector2

onready var area2D: Area2D = $Area2D
onready var animatedSprite: AnimatedSprite = $AnimatedSprite

# only certain frames of the animation should be considered damage frames
export var damage_frames: Array = []

# so we dont damage the same entity multiple times
const damaged_actors: Array = []

# exposed variables
export var damage: int = 0
export var speed: int = 10
export var player_relative_spawn_position: int = 15

export(Array, Resource) var on_hit_effects

export(Resource) var collision_effect



func _ready() -> void:
	animatedSprite.connect("animation_finished", self, "animation_finished")
	area2D.connect("area_entered", self, "area_entered")

func doAbility(attack_direction : Vector2, source: KinematicBody2D) -> void:
	source_actor = source
	if source_actor == GameState.player or source_actor.isPossessed():
		setCollideWithEnemies()
	else:
		setCollideWithPlayer()
	target_vector = attack_direction
	look_at(to_global(target_vector))
	animatedSprite.play()
	position = attack_direction.normalized() * player_relative_spawn_position

func setCollideWithEnemies() -> void:
	$Area2D.set_collision_mask_bit(2, true)

func setCollideWithPlayer() -> void:
	$Area2D.set_collision_mask_bit(1, true)

#func damageOverlappingAreas() -> void:
#	for area in area2D.get_overlapping_areas():
#		var area_parent = area.get_parent()
#		if (
#			area_parent != source_actor
#			and not damaged_actors.has(area_parent.get_instance_id())
#			and area.get_name() == 'HitBox'
#			and damage_frames.has(animatedSprite.get_frame())
#		):
#			damaged_actors.push_front(area_parent.get_instance_id())
#			area_parent.damage(damage)
#			area_parent.knockBack(
#				source_actor.get_angle_to(area_parent.get_global_position()),
#				200,
#				20
#			)
#			collisionEffect()

func collisionEffect() -> void:
	if is_instance_valid(collision_effect):
		var collision_effect_instance = collision_effect.instance()
		get_tree().get_root().add_child(collision_effect_instance)
		collision_effect_instance.position = target_actor.get_global_position()
		collision_effect_instance.play()

func _physics_process(_delta) -> void:
	if target_vector:
		target_vector = move_and_slide(target_vector.normalized() * speed)
#	if source_actor:
#		damageOverlappingAreas()

func animation_finished():
	queue_free()

func area_entered(area) -> void:
	var area_parent = area.get_parent()
	if (
		area_parent != source_actor
		and area.get_name() == 'HitBox'
		and not damaged_actors.has(area_parent.get_instance_id())
		and damage_frames.has(animatedSprite.get_frame())
	):
		damaged_actors.push_front(area_parent.get_instance_id())
		area_parent.damage(damage)
		area_parent.knockBack(
			source_actor.get_angle_to(area_parent.get_global_position()),
			200,
			20
		)
		collisionEffect()
		

# on create effect, so that we can make a small animation occur when the effect is first initialised ie: Muzzle flash

# the effect itelf, the swipe, the fireball etc.

# the onhit effect, which effect is created when the fireball or swipe hits a target or collides with something.
