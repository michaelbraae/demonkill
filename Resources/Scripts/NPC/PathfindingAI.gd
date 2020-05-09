extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var playerDetectionArea = $PlayerDetectionArea
onready var collisionRayCast = $CollisionRayCast

onready var navigation_mesh = get_parent()

const PLAYER_POSITION_OFFSET = 25

var interactable = false
var possessable = false
var path = []
var path_ind = 0
var move_speed = 180
var move_direction = 0
var vector_threshold = 0.1
var player
var velocity = Vector2()
var facing_direction = "down"

func setInteractable(interactable_value : bool) -> void:
	interactable = interactable_value

func setPossessable(possessable_value : bool) -> void:
	possessable = possessable_value

func setVectorThreshold(threshold) -> void:
	vector_threshold = threshold

func setMoveSpeed(speed) -> void:
	move_speed = speed

func setPlayer(player_var) -> void:
	player = player_var

func getAnimation() -> String:
	if velocity.x >= 45:
		animatedSprite.flip_h = false
		facing_direction = "right"
		return "run"
	if velocity.x <= -45:
		animatedSprite.flip_h = true
		facing_direction = "right"
		return "run"
	if velocity.y != 0:
		return "run"
	return "idle"

func detectPlayer() -> void:
	var playerDetectionOverlaps = playerDetectionArea.get_overlapping_areas()
	if playerDetectionOverlaps:
		for area in playerDetectionOverlaps:
			if area.get_parent().get("IS_PLAYER"):
				player = area.get_parent()

func alignRayCastToPlayer() -> void:
	collisionRayCast.rotation = get_angle_to(player.get_global_position())

func detectBlockers():
	var collider = collisionRayCast.get_collider()
	print("collider: ", collider)

func setNavigationPoint(target_position : Vector2) -> void:
	var closest_nav_point = navigation_mesh.get_closest_point(
		target_position
	)
	path = navigation_mesh.get_simple_path(
		global_transform.origin,
		closest_nav_point
	)
	path_ind = 0

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

func _process(_delta : float) -> void:
	detectPlayer()

func _physics_process(_delta : float) -> void:
	if player:
		alignRayCastToPlayer()
		detectBlockers()
		setPlayerLocationAsTargetVector()
		move_and_slide(velocity)
	elif velocity:
		setNavigationPoint(velocity)
		moveToNavigationPoint()
	animatedSprite.play(getAnimation())
