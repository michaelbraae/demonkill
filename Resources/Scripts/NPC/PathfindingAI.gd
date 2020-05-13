extends "res://Resources/Scripts/NPC/BaseAI.gd"

# dependencies, i know it's not clean. be nice :D
onready var playerDetectionArea = $PlayerDetectionArea
onready var collisionRayCast = $CollisionRayCast
onready var navigation_mesh = get_parent()

# used to stop animatedSprite.flip_h flickering when Y axis is aligned
const PLAYER_POSITION_OFFSET = 25

var path = []
var path_ind = 0
var path_blocked = false
var move_speed = 100
var vector_threshold = 0.05
var velocity = Vector2()

var player

func setVectorThreshold(threshold) -> void:
	vector_threshold = threshold

func setMoveSpeed(speed) -> void:
	move_speed = speed

func setPlayer(player_var : KinematicBody2D) -> void:
	player = player_var

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
		if not path_blocked:
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

func setPlayerLocationAsTargetVector() -> void:
	velocity = Vector2()
	var player_position = player.get_global_position()
	var ai_position = get_global_position()
	if player_position.x > ai_position.x:
		velocity.x += 1
	if player_position.x + PLAYER_POSITION_OFFSET < ai_position.x:
		velocity.x -= 1
	if player_position.y + PLAYER_POSITION_OFFSET > ai_position.y:
		velocity.y += 1
	if player_position.y - PLAYER_POSITION_OFFSET < ai_position.y:
		velocity.y -= 1
	velocity = velocity.normalized() * move_speed

func handleNavigation() -> void:
	if player:
		alignRayCastToPlayer()
		detectBlockers()
		if path_blocked:
			state = NAVIGATING
			setNavigationPoint(player.get_global_position())
			moveToNavigationPoint()
		else:
			state = FOLLOWING_PLAYER
			setPlayerLocationAsTargetVector()
			move_and_slide(velocity)
	else:
		state = IDLE

func _process(_delta : float) -> void:
	detectPlayer()

func _physics_process(_delta : float) -> void:
	handleNavigation()
