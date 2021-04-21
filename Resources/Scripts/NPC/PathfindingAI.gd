extends BaseAI

# remember to check the collision layer and mask
#	as well as signals to ensure proper function
class_name PathfindingAI

# Any new AI must have these nodes as children to use this script
onready var detectionArea = $DetectionArea
onready var collisionRayCast = $RayCast2D

#onready var navigation_mesh = get_parent()

# used to stop the animatedSprite flipping when Y axis is aligned
# Without this the sprite will flicker back and forth
const TARGET_POSITION_OFFSET = 2

# Steering Behaviour
export var detection_ray_count = 8

export var look_ahead = 100

var ray_directions = []
var interest = []
var danger = []

var chosen_direction = Vector2.ZERO
var velocity = Vector2.ZERO

# NavMesh Navigation
var path = []
var path_ind = 0
var path_blocked = false

# default move_speed for all PathFindingAI
var move_speed = 100

# The AI's current target
var target_actor

func _ready() -> void:
	interest.resize(detection_ray_count)
	danger.resize(detection_ray_count)
	ray_directions.resize(detection_ray_count)
	for i in detection_ray_count:
		var angle = i * 2 * PI / detection_ray_count
		ray_directions[i] = Vector2.RIGHT.rotated(angle)

func detectTarget() -> void:
	var detectionOverlaps = detectionArea.get_overlapping_areas()
	if detectionOverlaps:
		for area in detectionOverlaps:
			if GameState.state == GameState.CONTROLLING_PLAYER and area.get_parent().get('IS_PLAYER'):
				target_actor = area.get_parent()
			elif nodeIsPossessed(area.get_parent()):
				target_actor = PossessionState.possessedNPC
#
#func alignRayCastToPlayer() -> void:
#	collisionRayCast.rotation = getAngleToTarget()
#
#func getAngleToTarget() -> float:
#	return get_angle_to(target_actor.get_global_position())
#
#func detectBlockers():
#	var collider = collisionRayCast.get_collider()
#	if collider is StaticBody2D:
#		path_blocked = true
#	else:
#		path_blocked = false
#
#func setNavigationPoint(target_position : Vector2) -> void:
#	var closest_nav_point = navigation_mesh.get_closest_point(
#		target_position
#	)
#	path = navigation_mesh.get_simple_path(
#		global_transform.origin,
#		closest_nav_point
#	)
#	path_ind = 1
#
#func moveToNavigationPoint() -> void:
#	if path_ind < path.size():
#		var move_vec = (path[path_ind] - global_transform.origin)
#		if move_vec.length() < 0.05:
#			path_ind += 1
#		else:
#			move_vec = move_and_slide(move_vec.normalized() * move_speed)
#
#func setTargetLocationAsTargetVector() -> void:
#	velocity = Vector2()
#	var target_position = target_actor.get_global_position()
#	var ai_position = get_global_position()
#	if target_position.x > ai_position.x:
#		velocity.x += 1
#	if target_position.x + TARGET_POSITION_OFFSET < ai_position.x:
#		velocity.x -= 1
#	if target_position.y + TARGET_POSITION_OFFSET > ai_position.y:
#		velocity.y += 1
#	if target_position.y - TARGET_POSITION_OFFSET < ai_position.y:
#		velocity.y -= 1
#	velocity = velocity.normalized() * move_speed

func setInterest() -> void:
	if target_actor:
		var path_direction = get_global_position().direction_to(target_actor.get_global_position())
		for i in detection_ray_count:
			var d = ray_directions[i].rotated(rotation).dot(path_direction)
			interest[i] = max(0, d)
	else:
		setDefaultInterest()

func setDanger() -> void:
	var space_state = get_world_2d().direct_space_state
	for i in detection_ray_count:
		var result = space_state.intersect_ray(position,
				position + ray_directions[i].rotated(rotation) * look_ahead, [self])
		danger[i] = 1.0 if result else 0.0

func setDefaultInterest() -> void:
	# Default to moving forward
	for i in detection_ray_count:
		var d = ray_directions[i].rotated(rotation).dot(transform.x)
		interest[i] = max(0, d)

func chooseDirection():
	# Eliminate interest in slots with danger
	for i in detection_ray_count:
		if danger[i] > 0.0:
			interest[i] = 0.0
	# Choose direction based on remaining interest
	chosen_direction = Vector2.ZERO
	for i in detection_ray_count:
		chosen_direction += ray_directions[i] * interest[i]
	chosen_direction = chosen_direction.normalized()

#func deprecated_setDefaultInterest() -> void:
#	if target_actor:
#		alignRayCastToPlayer()
#		detectBlockers()
#		if path_blocked:
#			state = NAVIGATING
#			setNavigationPoint(target_actor.get_global_position())
#			moveToNavigationPoint()
#		else:
#			state = FOLLOWING_PLAYER
#			setTargetLocationAsTargetVector()
#			velocity = move_and_slide(velocity)
#	else:
#		state = IDLE

func runDecisionTree() -> void:
	if true:
		state = NAVIGATING
		setInterest()
		setDanger()
		chooseDirection()
		move_and_slide(chosen_direction * move_speed)
#	else:
#		deprecated_setDefaultInterest()
	print(interest)

func _process(_delta : float) -> void:
	detectTarget()

func _physics_process(_delta : float) -> void:
	runDecisionTree()
