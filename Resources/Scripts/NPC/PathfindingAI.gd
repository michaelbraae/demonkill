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
export var detection_ray_count = 12

export var look_ahead = 100

var ray_directions = []
var interest = []
var danger = []

var chosen_direction = Vector2.ZERO
var velocity = Vector2.ZERO

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

func detectTarget() -> void:
	var detectionOverlaps = detectionArea.get_overlapping_areas()
	if detectionOverlaps:
		for area in detectionOverlaps:
			if GameState.state == GameState.CONTROLLING_PLAYER and area.get_parent().get('IS_PLAYER'):
				target_actor = area.get_parent()
			elif nodeIsPossessed(area.get_parent()):
				target_actor = PossessionState.possessedNPC

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
				position + ray_directions[i].rotated(rotation) * 100, [self])
		if result and result['collider'] is StaticBody:
			print('StaticBody')
			danger[i] = 0.0
		elif result:
			danger[i] = 1.0

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

func runDecisionTree() -> void:
	state = NAVIGATING
	setInterest()
	setDanger()
	chooseDirection()
	$InterestVector.look_at(to_global(chosen_direction))
	move_and_slide(chosen_direction * move_speed)

func _physics_process(_delta : float) -> void:
	detectTarget()
	runDecisionTree()
