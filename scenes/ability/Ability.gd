extends KinematicBody2D

class_name Ability

enum ABILITY_TYPE {
	MELEE,
	PROJECTILE
}

var has_landed: bool = false

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

export(PackedScene) var on_create_effect

export(PackedScene) var collision_vfx

var damaged_characters: Array = []

# warning-ignore:unused_signal
signal ability_landed(ability_type)

func _ready() -> void:
	animatedSprite.connect("animation_finished", self, "animation_finished")

func has_lethal(hit_target: CharacterBase) -> bool:
	var damage_effect = get_node("Effects").find_node("DamageEffect")
	if damage_effect and damage_effect.damage >= hit_target.get_health():
		return true
	return false

func apply_lethal_damage(hit_target: CharacterBase) -> void:
	var damage_effect = get_node("Effects").find_node("DamageEffect")
	if damage_effect:
		hit_target.set_physics_process(true)
		hit_target.state = hit_target.PRE_DEATH
		hit_target.damage(damage_effect.damage)

# a VFX can be instantiated when the ability fires, ie: muzzle flash
func on_create_ability(attack_direction: Vector2) -> void:
	if is_instance_valid(on_create_effect) and attack_direction:
		var effect_instance = on_create_effect.instance()
		get_tree().get_root().add_child(effect_instance)
		effect_instance.look_at(attack_direction)
		effect_instance.play()
		effect_instance.position = source_actor.position + attack_direction.normalized() * player_relative_spawn_position

func do_ability(attack_direction : Vector2, source: KinematicBody2D) -> void:
	source_actor = source
	on_create_ability(attack_direction)
	if source_actor == GameState.player or source_actor.isPossessed():
		set_collide_with_enemies()
	else:
		set_collide_with_player()
	look_at(attack_direction)
	animatedSprite.play()
	position = source_actor.position + attack_direction.normalized() * player_relative_spawn_position

func set_collide_with_enemies() -> void:
	$Area2D.set_collision_mask_bit(2, true)
	set_collision_mask_bit(2, true)

func set_collide_with_player() -> void:
	$Area2D.set_collision_mask_bit(1, true)
	set_collision_mask_bit(1, true)

func collisionEffect(collision_position) -> void:
	if is_instance_valid(collision_vfx):
		var collision_effect_instance = collision_vfx.instance()
		get_tree().get_root().add_child(collision_effect_instance)
		collision_effect_instance.position = collision_position
		collision_effect_instance.play()

func animation_finished():
	if not continuous:
		queue_free()
