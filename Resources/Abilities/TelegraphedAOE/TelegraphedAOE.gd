extends Node2D

class_name TelegraphedAOE

onready var abilityBody = $AbilityBody
onready var abilityBodySprite = $AbilityBody/AnimatedSprite
onready var abilityBodyArea = $AbilityBody/Area2D

onready var targetLocation = $TargetLocation
onready var targetLocationSprite = $TargetLocation/AnimatedSprite
onready var targetLocationArea = $TargetLocation/Area2D
onready var targetLocationCollision = $TargetLocation/Area2D/CollisionShape2D

onready var hitBox = $TargetLocation/HitBox

var state
var target_vector
var move_speed
var target_id
var damage

var telegraphed = false
var target_hit = false

enum {
	IDLE, # When we want the ability to sit in place
	IN_TRANSIT, # When the ability is in flight - the telegraph should appear?
	IMPACT, # Reached it's destination and playing appropriate animation 
	AOE, # After landing
	DECAY, # when the AOE is disappearing
}

func _ready() -> void:
	setState(IDLE)
	targetLocationCollision.set_disabled(true)
	targetLocationSprite.hide()
	targetLocationSprite.play("active")

func setState(state_var : int) -> void:
	state = state_var

func getState() -> int:
	return state

func setTargetVector(target_vector_arg : Vector2) -> void:
	target_vector = target_vector_arg

func getTargetVector() -> Vector2:
	return target_vector

func setMoveSpeed(move_speed_var : float) -> void:
	move_speed = move_speed_var

func getMoveSpeed() -> float:
	return move_speed

func setTargetId(id_var : String) -> void:
	target_id = id_var

func getTargetId() -> String:
	return target_id

func setDamage(damage_var : int) -> void:
	damage = damage_var

func getDamage() -> int:
	return damage

func hasAOE() -> bool:
	return true

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

func _on_TargetLocation_animation_finished():
	match getState():
		IMPACT:
			if hasAOE():
				setState(AOE)
			else:
				setState(DECAY)
		AOE:
			setState(DECAY)
		DECAY:
			queue_free()

func playAnimationFromState() -> void:
	match getState():
		IDLE:
			abilityBodySprite.play("active")
		IN_TRANSIT:
			targetLocationSprite.play("active")
		IMPACT:
			targetLocationSprite.play("impact")

func readyToFire() -> bool:
	return true

func damageOverlappingPlayer() -> void:
	var overlappingAreas = hitBox.get_overlapping_areas()
	for area in overlappingAreas:
		var area_parent = area.get_parent()
		if area_parent.get("IS_PLAYER"):
			if not target_hit:
				target_hit = true
				print("PLAYER HIT!")

func _physics_process(_delta : float) -> void:
	match getState():
		IDLE:
			if readyToFire():
				setState(IN_TRANSIT)
				targetLocation.set_position(getTargetVector())
				targetLocationCollision.set_disabled(false)
				targetLocationSprite.show()
		IN_TRANSIT:
			sendAbilityBodyToTarget(getTargetVector())
		IMPACT:
			damageOverlappingPlayer()
	playAnimationFromState()


# TelegraphedAOEs should be able to stack;
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

