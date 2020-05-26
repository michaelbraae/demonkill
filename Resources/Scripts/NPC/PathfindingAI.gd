extends BaseAI

class_name PathfindingAI

# dependencies, i know it's not clean. be nice :D
# Any new AI must have these nodes as children to use this script
onready var playerDetectionArea = $PlayerDetectionArea
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

func setPlayer(player_var : KinematicBody2D) -> void:
	player = player_var

func getPlayer() -> KinematicBody2D:
	return player

func detectPlayer() -> void:
	var playerDetectionOverlaps = playerDetectionArea.get_overlapping_areas()
	if playerDetectionOverlaps:
		for area in playerDetectionOverlaps:
			if area.get_parent().get("IS_PLAYER"):
				setPlayer(area.get_parent())

func alignRayCastToPlayer() -> void:
	collisionRayCast.rotation = getAngleToPlayer()

func getAngleToPlayer() -> float:
	return get_angle_to(player.get_global_position())

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

func setPlayerLocationAsTargetVector() -> void:
	setVelocity(Vector2())
	var player_position = getPlayer().get_global_position()
	var ai_position = get_global_position()
	if player_position.x > ai_position.x:
		velocity.x += 1
	if player_position.x + PLAYER_POSITION_OFFSET < ai_position.x:
		velocity.x -= 1
	if player_position.y + PLAYER_POSITION_OFFSET > ai_position.y:
		velocity.y += 1
	if player_position.y - PLAYER_POSITION_OFFSET < ai_position.y:
		velocity.y -= 1
	setVelocity(getVelocity().normalized() * getMoveSpeed())

func runDecisionTree() -> void:
	print(getStateString())
	if getPlayer():
		alignRayCastToPlayer()
		detectBlockers()
		if getPathBlocked():
			print("PATH BLOCKED")
			setState(NAVIGATING)
			setNavigationPoint(player.get_global_position())
			moveToNavigationPoint()
		else:
			setState(FOLLOWING_PLAYER)
			setPlayerLocationAsTargetVector()
			move_and_slide(getVelocity())
	else:
		setState(IDLE)
		# they AI should follow a path in this situation
		# or potentially idle

func _process(_delta : float) -> void:
	detectPlayer()

func _physics_process(_delta : float) -> void:
	runDecisionTree()
