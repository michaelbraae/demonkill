extends BaseAI

# remember to check the collision layer and mask
#	as well as signals to ensure proper function
class_name PathfindingAI

# Any new AI must have these nodes as children to use this script
onready var detectionArea = $DetectionArea
onready var collisionRayCast = $CollisionRayCast
onready var navigation_mesh = get_parent()

# used to stop the animatedSprite flipping when Y axis is aligned
# Without this the sprite will flicker back and forth
const TARGET_POSITION_OFFSET = 2

var path = []
var path_ind = 0
var path_blocked = false
var move_speed = 100
var vector_threshold = 0.05
var velocity = Vector2()

var player

var target_actor

func detectTarget() -> void:
	var detectionOverlaps = detectionArea.get_overlapping_areas()
	if detectionOverlaps:
		for area in detectionOverlaps:
			if GameState.state == GameState.CONTROLLING_PLAYER and area.get_parent().get('IS_PLAYER'):
				target_actor = area.get_parent()
			elif nodeIsPossessed(area.get_parent()):
				target_actor = PossessionState.possessedNPC

func alignRayCastToPlayer() -> void:
	collisionRayCast.rotation = getAngleToTarget()

func getAngleToTarget() -> float:
	return get_angle_to(target_actor.get_global_position())

func detectBlockers():
	var collider = collisionRayCast.get_collider()
	if collider is StaticBody2D:
		path_blocked = true
	else:
		path_blocked = false

func setNavigationPoint(target_position : Vector2) -> void:
	var closest_nav_point = navigation_mesh.get_closest_point(
		target_position
	)
	path = navigation_mesh.get_simple_path(
		global_transform.origin,
		closest_nav_point
	)
	path_ind = 1

func moveToNavigationPoint() -> void:
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < vector_threshold:
			path_ind += 1
		else:
			move_and_slide(move_vec.normalized() * move_speed)

func setTargetLocationAsTargetVector() -> void:
	velocity = Vector2()
	var target_position = target_actor.get_global_position()
	var ai_position = get_global_position()
	if target_position.x > ai_position.x:
		velocity.x += 1
	if target_position.x + TARGET_POSITION_OFFSET < ai_position.x:
		velocity.x -= 1
	if target_position.y + TARGET_POSITION_OFFSET > ai_position.y:
		velocity.y += 1
	if target_position.y - TARGET_POSITION_OFFSET < ai_position.y:
		velocity.y -= 1
	velocity = velocity.normalized() * move_speed

func runDecisionTree() -> void:
	if target_actor:
		alignRayCastToPlayer()
		detectBlockers()
		if path_blocked:
			state = NAVIGATING
			setNavigationPoint(target_actor.get_global_position())
			moveToNavigationPoint()
		else:
			state = FOLLOWING_PLAYER
			setTargetLocationAsTargetVector()
			move_and_slide(velocity)
	else:
		state = IDLE

func _process(_delta : float) -> void:
	detectTarget()

func _physics_process(_delta : float) -> void:
	runDecisionTree()
