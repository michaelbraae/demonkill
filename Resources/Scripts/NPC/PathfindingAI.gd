extends KinematicBody2D

onready var navigation_mesh = get_parent()

const PLAYER_POSITION_OFFSET = 25

var interactable = false
var possessable = false
var path = []
var path_ind = 0
var move_speed = 100
var move_direction = 0
var vector_threshold = 0.1
var player

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

# this one is fucked
func getWanderVector() -> Vector2:
	return Vector2(64, -320)

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

func getPlayerLocationVector() -> Vector2:
	var velocity = Vector2()
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
	return velocity.normalized() * move_speed

func _physics_process(_delta : float) -> void:
	if player:
		setNavigationPoint(getPlayerLocationVector())
	else:
		setNavigationPoint(getWanderVector())
	moveToNavigationPoint()
