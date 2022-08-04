extends KinematicBody2D

class_name CharacterBase

onready var animatedSprite = $AnimatedSprite

# --- KNOCKBACK LOGIC --- #
var knocked_back = false
var knockback_vector
var speed = 300
var speed_current = speed
var decay

func _ready() -> void:
	animatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")

# these functions are called by signals emitted by InputEmitter
func basic_attack() -> void:
	pass

func movement_ability() -> void:
	pass

func use_ability() -> void:
	pass

func possession_cast_begun() -> void:
	pass

func possession_cast_ended() -> void:
	pass

func getKnockBackProcessVector() -> Vector2:
	if speed_current < 10:
		speed_current = speed
		knocked_back = false
	speed_current -= decay
	return knockback_vector.normalized() * speed_current

func interruptAction() -> void:
	pass

func freeze(freeze_duration) -> void:
	set_physics_process(false)
	animatedSprite.stop()
	yield(get_tree().create_timer(freeze_duration), "timeout")
	set_physics_process(true)
	animatedSprite.play()

func knockBack(
	hit_direction : float,
	knock_back_speed : int,
	knock_back_decay : int
) -> void:
	if not knocked_back:
		interruptAction()
		knocked_back = true
		speed = knock_back_speed
		decay = knock_back_decay
		knockback_vector = Vector2(cos(hit_direction), sin(hit_direction))
