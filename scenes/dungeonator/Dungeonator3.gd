tool
extends Node2D

export(bool) var build_dungeon setget trigger_dungeon_build

var room_size = 100

var font = preload("res://assets/RobotoBold120.tres")

var TEST_START_ROOM = preload("res://scenes/dungeonator/rooms/1/StartRoom.tscn")
var TEST_ENCOUNTER = preload("res://scenes/encounter/encounters/TestEncounter.tscn")
var TEST_END_ROOM = preload("res://scenes/dungeonator/rooms/1/StartRoom.tscn")


# Define the size of each chunk
const CHUNK_SIZE = Vector2(10, 10)

# Define the number of chunks in the dungeon
const DUNGEON_SIZE = Vector2(20, 20)

# Define the room scenes to use for each room type
#var ROOM_SCENES = {
#	"encounter": TEST_ENCOUNTER,
#	"hub": TEST_ENCOUNTER,
#	"shop": TEST_ENCOUNTER,
#}

var example_prefab = {
	"archetype": "dungeon-lower",
	"stage": 1,
	"rooms": {
		1: "encounter",
		2: "encounter",
		3: "encounter",
		4: "encounter",
		5: "hub",
		6: "shop",
		7: "encounter",
	},
}

# Define constants for the dungeon size
const DUNGEON_WIDTH = 10
const DUNGEON_HEIGHT = 10

# Define a constant for the minimum distance between rooms
const ROOM_MIN_DISTANCE = 550

onready var tilemap: TileMap = $TileMap

func trigger_dungeon_build(value):
	if value:
		generate_dungeon()

# Define a function to check if a room overlaps with any other rooms
func is_room_overlapping(room_rect: Rect2, rooms: Array) -> bool:
	for other_room_rect in rooms:
		if room_rect.intersects(other_room_rect):
			return true
	return false

var ROOM_SCENES = [
	TEST_START_ROOM,
	TEST_ENCOUNTER,
	TEST_ENCOUNTER,
	TEST_ENCOUNTER,
	TEST_ENCOUNTER,
	TEST_ENCOUNTER,
	TEST_END_ROOM
]

# Define a function to create a new room
func create_room(scene: PackedScene, position: Vector2) -> Node:
	var room = scene.instance()
	room.position = position
	
	var grid_size = Vector2(16, 16)  # Set the size of your grid here
	room.position = Vector2(round(room.position.x/grid_size.x) * grid_size.x, round(room.position.y/grid_size.y)*grid_size.y)

	add_child(room)
	return room

func generate_dungeon():
	# Initialize the starting room
	var current_room = create_room(ROOM_SCENES[0], Vector2(0, 0))
	var previous_room = current_room
	var direction = Vector2(1, 0)

	# Generate the remaining rooms
	var visited_positions = [Vector2.ZERO]
	for i in range(1, len(ROOM_SCENES)):
		# Generate a new random direction
		direction = direction.rotated(rand_range(-PI, PI))

		# Calculate the position of the new room
		var position = previous_room.position + direction * (previous_room.get_node("TileMap").get_used_rect().size + Vector2(ROOM_MIN_DISTANCE, ROOM_MIN_DISTANCE))
		
		# Check if the new room overlaps with any previously visited rooms
		var overlap = false
		for visited_position in visited_positions:
			if position.distance_to(visited_position) < ROOM_MIN_DISTANCE:
				overlap = true
				break
		
		# If the new room overlaps, generate a new random direction
		if overlap:
			direction = direction.rotated(rand_range(-PI, PI))
			position = previous_room.position + direction * (previous_room.get_node("TileMap").get_used_rect().size + Vector2(ROOM_MIN_DISTANCE, ROOM_MIN_DISTANCE))
		
		# Create the new room and update the previous room
		current_room = create_room(ROOM_SCENES[i], position)
		
		# Update the previous room and visited positions
		previous_room = current_room
		visited_positions.append(position)
	
	# Center the dungeon in the viewport
	var viewport = get_viewport()
	var viewport_size = viewport.size
	var dungeon_size = Vector2(DUNGEON_WIDTH, DUNGEON_HEIGHT) * tilemap.cell_size
	tilemap.set_position((viewport_size - dungeon_size) / 2)
