extends KinematicBody2D

# All core functionality regarding states
#	and their transitions should go here if possible

var state
onready var animatedSprite = $AnimatedSprite

# STATES:
enum {
	IDLE,
	WANDERING,
	NAVIGATING,
	FOLLOWING_PLAYER,
	PRE_ATTACK,
	ATTACKING,
	POST_ATTACK,
	TAKING_DAMAGE,
	PRE_DEATH,
	DEATH,
}

func _on_AnimatedSprite_animation_finished() -> void:
	handlePostAnimState()

func handlePostAnimState() -> void:
	pass
