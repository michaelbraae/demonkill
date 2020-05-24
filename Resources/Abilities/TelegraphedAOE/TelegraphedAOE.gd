extends Node2D

class_name TelegraogedAOE

onready var abilityBody = $AbilityBody
onready var abilitySprite = $AbilityBody/AnimatedSprite
onready var telegraphSprite = $TelegraphSprite

var state
var target_vector
var move_speed
var target_id
var damage

enum {
	IDLE, # When we want the ability to sit in place
	IN_TRANSIT, # When the ability is in flight
	IMPACT, # Reached it's destination and playing appropriate animation 
	AOE, # After landing
	DECAY, # when the AOE is disappearing
}

func _ready() -> void:
	hideTelegraphSprite()

func hideTelegraphSprite() -> void:
	telegraphSprite.hide()
	telegraphSprite.play("active")

func setState(state_var : int) -> void:
	state = state_var

func getState() -> int:
	return state

func setTargetVector(target_vector_arg : Vector2) -> void:
	target_vector = target_vector_arg

func getTargetVector() -> Vector2:
	return target_vector

func setMoveSpeed(move_speed_var : int) -> void:
	move_speed = move_speed_var

func getMoveSpeed() -> int:
	return move_speed

func setTargetId(id_var : String) -> void:
	target_id = id_var

func getTargetId() -> String:
	return target_id

func setDamage(damage_var : int) -> void:
	damage = damage_var

func getDamage() -> int:
	return damage

func positionTelegraphSprite() -> void:
	telegraphSprite.set_position(getTargetVector())

func getAbilityBodyAnimation() -> String:
	var state_animation
	match getState():
		IDLE:
			state_animation = "idle"
		IN_TRANSIT:
			state_animation = "in_transit"
		IMPACT:
			state_animation = "impact"
		AOE:
			state_animation = "aoe"
		DECAY:
			state_animation = "decay"
	return state_animation

func getTelegraphAnimation() -> String:
	return "active"

func sendProjectileToTarget() -> void:
	var projectile_vector = getTargetVector()
	if projectile_vector:
		rotation = projectile_vector.angle()
		# hide the sprite until after it's rotated
		abilitySprite.show()
		var collision = abilityBody.move_and_collide(
			projectile_vector.normalized() * getMoveSpeed()
		)
		if collision:
			var collider = collision.get_collider()
			if collider.get(getTargetId()):
				collider.damage(getDamage())
			queue_free()
	else:
		queue_free()

# telegraphedAOEs should be able to stack;
#	ie: multiple AOEs can be fired at once. and an effect should play.

# perhaps an AbilityHandler class could control this.

# target vectors should be calculated relative to the caster
#	when using an ability handler
#	ie: if the ability is rotating around the player at the time of firing.
#	it should have an adjusted target_vectorso that it hits the correct location
#		this calculation should be done based on the ability handlers pattern

# the aiming should be relative to the caster
#	not necessarily the abilities position

# the ability body can be active before the telegraph appears.

# move the TelegraphSprite to the target vector then play.

# move the AbilityBody toward the target vector at the variable speed rate

# Once the abilityBody reaches the target vector. Stop playing the telegraph sprite

# The Area2D should only be hitting the player when it's reached the location

# The on hit animation should then play.

# after that the AOE animation should play if there is one.
