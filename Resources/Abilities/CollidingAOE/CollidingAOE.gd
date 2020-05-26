extends Node2D

class_name CollidingAOE

onready var abilityBody = $AbilityBody
onready var abilityBodyCollision = $AbilityBody/CollisionShape2D
onready var abilityBodyArea = $AbilityBody/Area2D
onready var abilityBodySprite = $AbilityBody/AnimatedSprite

onready var targetLocation = $TargetLocation
onready var targetLocationArea = $TargetLocation/Area2D
onready var targetLocationCollision = $TargetLocation/Area2D/CollisionShape2D

var state
var move_speed

enum {
	IDLE, # When we want the ability to sit in place
	IN_TRANSIT, # When the ability is in flight - the telegraph should appear?
	IMPACT, # Reached it's destination and playing appropriate animation 
	AOE, # After landing
	DECAY, # when the AOE is disappearing
}

func setState(state_var : int) -> void:
	state = state_var

func getState() -> int:
	return state

func setMoveSpeed(move_speed_var : float) -> void:
	move_speed = move_speed_var

func getMoveSpeed() -> float:
	return move_speed

func _ready() -> void:
	setState(IDLE)
	targetLocationCollision.set_disabled(true)

func sendAbilityBodyToTarget(projectile_vector : Vector2) -> void:
	abilityBodySprite.set_rotation(projectile_vector.angle())
	abilityBodySprite.show()
	abilityBody.move_and_collide(
		projectile_vector.normalized() * getMoveSpeed()
	)
	if (
		getState() == IN_TRANSIT
		and abilityBodyArea.overlaps_area(targetLocationArea)
	):
		setState(IMPACT)
		abilityBody.queue_free()
