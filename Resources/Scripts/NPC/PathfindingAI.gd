extends BaseAI

# remember to check the collision layer and mask
#	as well as signals to ensure proper function
class_name PathfindingAI

# Any new AI must have these nodes as children to use this script
onready var playerDetectionArea = $PlayerDetectionArea
onready var detectionArea = $DetectionArea
onready var collisionRayCast = $CollisionRayCast
onready var navigation_mesh = get_parent()

# used to stop the animatedSprite flipping when Y axis is aligned
# Without this the sprite will flicker back and forth
const PLAYER_POSITION_OFFSET = 25

var path = []
var path_ind = 0
var path_blocked = false
var move_speed = 100
var vector_threshold = 0.05
var velocity = Vector2()

var player

var target_actor

func setPathBlocked(blocked_var : bool) -> void:
	path_blocked = blocked_var

func getPathBlocked() -> bool:
	return path_blocked

func setMoveSpeed(speed : float) -> void:
	move_speed = speed

func getMoveSpeed() -> float:
	return move_speed

func setVectorThreshold(threshold : float) -> void:
	vector_threshold = threshold

func getVectorThreshold() -> float:
	return vector_threshold

func setVelocity(velocity_arg : Vector2) -> void:
	velocity = velocity_arg

func getVelocity() -> Vector2:
	return velocity

func setTarget(target_var : KinematicBody2D) -> void:
	target_actor = target_var

func getTarget() -> KinematicBody2D:
	return target_actor

func detectTarget() -> void:
	var detectionOverlaps = detectionArea.get_overlapping_areas()
	if detectionOverlaps:
		for area in detectionOverlaps:
			if GameState.state == GameState.CONTROLLING_PLAYER and area.get_parent().get("IS_PLAYER"):
				setTarget(area.get_parent())
			elif GameState.state == GameState.CONTROLLING_NPC and area.get_parent() == PossessionState.possessedNPC:
				setTarget(PossessionState.possessedNPC)

func alignRayCastToPlayer() -> void:
	collisionRayCast.rotation = getAngleToTarget()

func getAngleToTarget() -> float:
	return get_angle_to(getTarget().get_global_position())

func detectBlockers():
	var collider = collisionRayCast.get_collider()
	if collider is StaticBody2D:
		setPathBlocked(true)
	else:
		setPathBlocked(false)

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
		if move_vec.length() < getVectorThreshold():
			path_ind += 1
		else:
			move_and_slide(move_vec.normalized() * getMoveSpeed())

func setTargetLocationAsTargetVector() -> void:
	setVelocity(Vector2())
	var target_position = getTarget().get_global_position()
	var ai_position = get_global_position()
	if target_position.x > ai_position.x:
		velocity.x += 1
	if target_position.x + PLAYER_POSITION_OFFSET < ai_position.x:
		velocity.x -= 1
	if target_position.y + PLAYER_POSITION_OFFSET > ai_position.y:
		velocity.y += 1
	if target_position.y - PLAYER_POSITION_OFFSET < ai_position.y:
		velocity.y -= 1
	setVelocity(getVelocity().normalized() * getMoveSpeed())

func runDecisionTree() -> void:
	if getTarget():
		alignRayCastToPlayer()
		detectBlockers()
		if getPathBlocked():
			setState(NAVIGATING)
			setNavigationPoint(getTarget().get_global_position())
			moveToNavigationPoint()
		else:
			setState(FOLLOWING_PLAYER)
			setTargetLocationAsTargetVector()
			move_and_slide(getVelocity())
	else:
		setState(IDLE)

func _process(_delta : float) -> void:
	detectTarget()

func _physics_process(_delta : float) -> void:
	runDecisionTree()
