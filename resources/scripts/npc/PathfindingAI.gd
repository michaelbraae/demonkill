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

export var look_ahead = 30

# 70 - feels aggressive
# 100 - feels safer
var target_engagement_range = 50

var ray_directions = []
var interest = []
var danger = []

var chosen_direction = Vector2.ZERO
var velocity = Vector2.ZERO

# dodge logic
var dodge_timer
var dodge_cooldown_timer
var in_dodge
var dodge_vector

#dodge variable logic
var dodge_cooldown = 2

# default move_speed for all PathFindingAI
export var move_speed: float = 120.0

# The AI's current target
var target_actor





# every few seconds, if the AI is still trying to chase the player
# and the player is visible
# add the players location to the last_know_position variable
# path find towards the last known position until the position is reached

# only overwrite the LNP if the player is visible at that moment
# otherwise continue towards to previously set last known position


# when the AI sees the player add the player location to this var
# if the  reaches the 

var nav_line: Line2D = Line2D.new()
var nav_line_2: Line2D = Line2D.new()


func _ready() -> void:
#	nav_line_2.set_default_color(Color(1, 0.9, 1, 1))
##	get_parent().add_child(nav_line_2)
#	get_parent().add_child(nav_line)
	spawn_position = get_position()
	interest.resize(detection_ray_count)
	danger.resize(detection_ray_count)
	ray_directions.resize(detection_ray_count)
	for i in detection_ray_count:
		var angle = i * 2 * PI / detection_ray_count
		ray_directions[i] = Vector2.RIGHT.rotated(angle)
	dodge_timer = Timer.new()
	dodge_timer.connect('timeout', self, 'dodge_timeout')
	add_child(dodge_timer)
	
	dodge_cooldown_timer = Timer.new()
	dodge_cooldown_timer.connect('timeout', self, 'dodge_cooldown_timeout')
	add_child(dodge_cooldown_timer)
	
	navigation_reset_timer = Timer.new()
	# warning-ignore:return_value_discarded
	navigation_reset_timer.connect('timeout', self, 'navigation_reset_timeout')
	add_child(navigation_reset_timer)

func dodge_timeout() -> void:
	in_dodge = false
	dodge_timer.stop()

func dodge_cooldown_timeout() -> void:
	dodge_cooldown_timer.stop()

func navigation_reset_timeout() -> void:
	navigation_reset_timer.stop()

func detectTarget() -> void:
	var detectionOverlaps = detectionArea.get_overlapping_areas()
	if detectionOverlaps:
		for area in detectionOverlaps:
			if GameState.state == GameState.CONTROLLING_PLAYER and area.get_parent() == GameState.player:
				target_actor = area.get_parent()
			elif nodeIsPossessed(area.get_parent()):
				target_actor = PossessionState.current_possession

func getDistanceToTarget():
	return get_global_position().distance_to(target_actor.get_global_position())

func isTargetInEngagementRange() -> bool:
	if getDistanceToTarget() <= target_engagement_range:
		return true
	return false

func setInterest() -> void:
	if is_instance_valid(target_actor):
		var path_direction = get_global_position().direction_to(target_actor.get_global_position())
		for i in detection_ray_count:
			var d = ray_directions[i].rotated(rotation).dot(path_direction)
			interest[i] = max(0, d)

func setDanger() -> void:
	var space_state = get_world_2d().direct_space_state
	for i in detection_ray_count:
		danger[i] = 0.0
		var result = space_state.intersect_ray(position,
				position + ray_directions[i].rotated(rotation) * look_ahead, [self])
		if result:
			danger[i] = 1.0

func detectTargetAggression() -> void:
	if is_instance_valid(target_actor):
		var space_state = get_world_2d().direct_space_state
		if target_actor.velocity:
			var result = space_state.intersect_ray(
				target_actor.position,
				target_actor.position + target_actor.velocity * 200,
				[target_actor]
			)
			if result and result['collider'] == self and is_instance_valid(target_actor) and getDistanceToTarget() < 100:
				if dodge_cooldown_timer.is_stopped():
					dodge_vector = target_actor.velocity
					dodge_cooldown_timer.start(dodge_cooldown)
					in_dodge = true
					dodge_timer.start(0.3)

func chooseDirection():
	# Eliminate interest in slots with danger
	for i in detection_ray_count:
		if danger[i] > 0.0:
			interest[i] = 0.0
	# Choose direction based on remaining interest
	chosen_direction = Vector2.ZERO
	for i in detection_ray_count:
		chosen_direction += ray_directions[i] * interest[i]
	
	if not in_dodge and not dodge_cooldown_timer.is_stopped():
		# once the dodge has finished, but it's still on cooldown
		# they should be aggresive
		pass
	elif is_instance_valid(target_actor) and isTargetInEngagementRange():
		# Orbit the target if in engagement range
		detectTargetAggression()
		chosen_direction = chosen_direction.rotated(1.5)
	if in_dodge:
		chosen_direction = dodge_vector
	velocity = chosen_direction.normalized()

func getMoveSpeed() -> float:
	if in_dodge:
		return move_speed * 2
	return move_speed

func hasLineOfSight() -> bool:
	if !is_instance_valid(target_actor):
		return false
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(get_global_position(), target_actor.get_global_position(), [self])
	if result and result['collider'] == target_actor:
		return true
	return false

var spawn_position
var max_wander_distance = 400

func decideContinueChasingTarget() -> bool:
	# if the target has line of sight then it's okay to continue
	if hasLineOfSight():
		return true
	if get_position().distance_to(spawn_position) > max_wander_distance:
		return false
	return true

var navigation_reset_timer: Timer
const navigation_reset: float = 1.0
var navigation_path: PoolVector2Array = []
var next_position = Vector2.ZERO

func navigateAlongPath(target_position) -> void:
	if navigation_path.size() > 1:
		next_position = next_position.linear_interpolate(navigation_path[1], 0.8)
		if position.distance_to(navigation_path[1]) < 1:
			navigation_path.remove(0)
	else:
		# reset the navigation path if the length is very short
		navigation_path = calculate_point_path(target_position)
	
	# draw a line here to show the intention of the AI
#	nav_line.clear_points()
#	nav_line_2.clear_points()
	for nav_location in navigation_path:
#		nav_line.add_point(Vector2(nav_location.x, nav_location.y))
#		nav_line_2.add_point(Vector2(nav_location.x + 8, nav_location.y + 8))
		pass
	
#	next_position = Vector2(next_position.x + 8, next_position.y + 8)
	var angle_to_navigation_point = get_angle_to(next_position)
	
	velocity = Vector2(cos(angle_to_navigation_point), sin(angle_to_navigation_point))

func runDecisionTree() -> void:
	state = NAVIGATING
	if not decideContinueChasingTarget():
		navigation_path = calculate_point_path(spawn_position)
		navigateAlongPath(spawn_position)
	elif is_instance_valid(target_actor) and is_instance_valid(GameState.tilemap) and not hasLineOfSight():
		if navigation_reset_timer.is_stopped() or !navigation_path:
			navigation_reset_timer.start(navigation_reset)
			navigation_path = calculate_point_path(target_actor.get_position())
		navigateAlongPath(target_actor.get_position())
		# read the path coordinates as the center of the tile (tile_size = 16)
	else:
		setInterest()
		setDanger()
		chooseDirection()
	$InterestVector.look_at(to_global(velocity))
	# warning-ignore:return_value_discarded
	move_and_slide(velocity * getMoveSpeed())

func calculate_point_path(target_position) -> PoolVector2Array:
	var current_location_in_tilemap = GameState.astar.get_closest_point(get_position())
	var target_location_in_tilemap = GameState.astar.get_closest_point(target_position)
	return GameState.astar.get_point_path(current_location_in_tilemap, target_location_in_tilemap)

func _physics_process(_delta : float) -> void:
	detectTarget()
	runDecisionTree()
