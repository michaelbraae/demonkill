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

export var continuous: bool = false

# exposed variables
export var speed: int = 10
# how far away from the player will this ability spawn
export var player_relative_spawn_position: int = 15

export(Array, PackedScene) var on_hit_effects

export(PackedScene) var on_create_effect

export(PackedScene) var collision_effect

var damaged_characters: Array = []

func _ready() -> void:
	animatedSprite.connect("animation_finished", self, "animation_finished")

# a VFX can be instantiated when the ability fires, ie: muzzle flash
func onCreateAbility(attack_direction: Vector2) -> void:
	if is_instance_valid(on_create_effect):
		var effect_instance = on_create_effect.instance()
		effect_instance.look_at(attack_direction)
		effect_instance.play()
		effect_instance.position = source_actor.position + attack_direction.normalized() * player_relative_spawn_position
		get_tree().get_root().add_child(effect_instance)

func doAbility(attack_direction : Vector2, source: KinematicBody2D) -> void:
	source_actor = source
	onCreateAbility(attack_direction)
	if source_actor == GameState.player or source_actor.isPossessed():
		setCollideWithEnemies()
	else:
		setCollideWithPlayer()
	look_at(attack_direction)
	animatedSprite.play()
	position = source_actor.position + attack_direction.normalized() * player_relative_spawn_position

func setCollideWithEnemies() -> void:
	$Area2D.set_collision_mask_bit(2, true)
	set_collision_mask_bit(2, true)

func setCollideWithPlayer() -> void:
	$Area2D.set_collision_mask_bit(1, true)
	set_collision_mask_bit(1, true)

func collisionEffect(collision_position) -> void:
	if is_instance_valid(collision_effect):
		var collision_effect_instance = collision_effect.instance()
		get_tree().get_root().add_child(collision_effect_instance)
		collision_effect_instance.position = collision_position
		collision_effect_instance.play()

func animation_finished():
	if not continuous:
		queue_free()
