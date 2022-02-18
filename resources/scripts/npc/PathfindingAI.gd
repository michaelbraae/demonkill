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
var move_speed = 120

# The AI's current target
var target_actor

func _ready() -> void:
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

func dodge_timeout() -> void:
	in_dodge = false
	dodge_timer.stop()

func dodge_cooldown_timeout() -> void:
	dodge_cooldown_timer.stop()

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
	if target_actor:
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
	if target_actor:
		var space_state = get_world_2d().direct_space_state
		if target_actor.velocity:
			var result = space_state.intersect_ray(
				target_actor.position,
				target_actor.position + target_actor.velocity * 200,
				[target_actor]
			)
			if result and result['collider'] == self and getDistanceToTarget() < 100:
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
	elif isTargetInEngagementRange():
		# Orbit the target if in engagement range
		detectTargetAggression()
		chosen_direction = chosen_direction.rotated(1.5)
	# detectTargetAggression() has resulted in need for dodge
	if in_dodge:
		chosen_direction = dodge_vector
	velocity = chosen_direction.normalized()

func getMoveSpeed() -> int:
	if in_dodge:
		return move_speed * 2
	return move_speed

func runDecisionTree() -> void:
	state = NAVIGATING
	setInterest()
	setDanger()
	chooseDirection()
	$InterestVector.look_at(to_global(velocity))
	move_and_slide(velocity * getMoveSpeed())

func _physics_process(_delta : float) -> void:
	detectTarget()
	runDecisionTree()
