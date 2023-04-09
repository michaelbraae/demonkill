tool
extends Node2D

export(bool) var build_dungeon setget trigger_dungeon_build

export(bool) var clear_dungeon setget trigger_dungeon_clear

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
		setup_tilemap()
		generate_dungeon()
		connect_room_paths()

func trigger_dungeon_clear(value) -> void:
	if value:
		for room in $Rooms.get_children():
			room.queue_free()
		setup_tilemap()
		tilemap.clear()

func setup_tilemap() -> void:
	tilemap = get_node("TileMap")

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

	$Rooms.add_child(room)
	return room

const PATH_BEGIN = 1
const PATH_END = 2

func generate_dungeon():
	# Initialize the starting room
	var current_room = create_room(ROOM_SCENES[0], Vector2(0, 0))
	var previous_room = current_room
	var direction = Vector2(1, 0)
	
	# Initialize variables to keep track of closest Position2d nodes
	var closest_to_prev_room: Position2D = null
	var closest_to_next_room: Position2D = null
	var closest_distance_to_prev_room = 0
	var closest_distance_to_next_room = 0
	
	var start_room
	var end_room
	
	# Generate the remaining rooms
	var visited_positions = [Vector2.ZERO]
	for i in range(1, len(ROOM_SCENES)):
		
		# Generate a new random direction
		direction = direction.rotated(rand_range(-PI/6, PI/6))

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
			direction = direction.rotated(rand_range(-PI/6, PI/6))
			position = previous_room.position + direction * (previous_room.get_node("TileMap").get_used_rect().size + Vector2(ROOM_MIN_DISTANCE, ROOM_MIN_DISTANCE))
		
		# Create the new room and update the previous room
		current_room = create_room(ROOM_SCENES[i], position)
		
		if i == 1:
			start_room = current_room
		if i == len(ROOM_SCENES):
			end_room = current_room
		
		# Update the previous room and visited positions
		previous_room = current_room
		visited_positions.append(position)
		
	# Center the dungeon in the viewport
	var viewport = get_viewport()
	var viewport_size = viewport.size
	var dungeon_size = Vector2(DUNGEON_WIDTH, DUNGEON_HEIGHT) * tilemap.cell_size
	tilemap.set_position((viewport_size - dungeon_size) / 2)

func connect_room_paths() -> void:
	var rooms = $Rooms.get_children()
	# for each room, if the next room exists,
	# find the door which is closest to that room
	
	# if the previous room exists
	# find the door which is closest to that room
	
	for i in len(rooms):
		var closest_distance_to_prev_room = 0
		var closest_door_to_prev_room: Position2D
		
		var closest_distance_to_next_room = 0
		var closest_door_to_next_room: Position2D
		
		for door in rooms[i].get_node("Doors").get_children():
			var previous_room
			var next_room
			
			if range(rooms.size()).has(i-1) && i != 1:
				previous_room = rooms[i-1]
			if range(rooms.size()).has(i+1):
				next_room = rooms[i+1]
			
			if previous_room:
				var door_distance_to_prev_room = door.global_position.distance_to(previous_room.global_position)
				
				if !closest_distance_to_prev_room:
					closest_distance_to_prev_room = door_distance_to_prev_room
					closest_door_to_prev_room = door
				
				if door_distance_to_prev_room < closest_distance_to_prev_room:
					closest_distance_to_prev_room = door_distance_to_prev_room
					closest_door_to_prev_room = door
			
			if next_room:
				var door_distance_to_next_room = door.global_position.distance_to(next_room.global_position)
				
				if !closest_distance_to_next_room:
					closest_distance_to_next_room = door_distance_to_next_room
					closest_door_to_next_room = door
				
				if door_distance_to_next_room < closest_distance_to_next_room:
					closest_distance_to_next_room = door_distance_to_next_room
					closest_door_to_next_room = door
		
		if closest_door_to_prev_room:
			closest_door_to_prev_room.set_meta("door_position", PATH_END)
		if closest_door_to_next_room:
			closest_door_to_next_room.set_meta("door_position", PATH_BEGIN)
	
	var path_start
	var path_end
	for i in len(rooms):
		for door in rooms[i].get_node("Doors").get_children():
			if door.get_meta("door_position") == PATH_BEGIN:
				path_start = door.position
			if door.get_meta("door_position") == PATH_END:
				path_end = door.position
			if path_start and path_end:
				break
		carve_path(path_start, path_end)

func carve_path(pos1, pos2):
	print("carve_path()")
	# Carve a path between two points
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0: y_diff = pow(-1.0, randi() % 2)
	
	# choose either x/y or y/x
	var x_y = pos1
	var y_x = pos2
	
	for x in range(pos1.x, pos2.x, x_diff):
		# skip if the cell is a background tile
		if tilemap.get_cell(x, x_y.y) == 0:
			pass
		else:
			# make the current tile the correct sprite
			tilemap.set_cell(x, x_y.y, 0)
			# widen the corridor both ways in y axis
			tilemap.set_cell(x, x_y.y + y_diff, 0)
			tilemap.set_cell(x, x_y.y - y_diff, 0)
			
	for y in range(pos1.y, pos2.y, y_diff):
		if tilemap.get_cell(y_x.x, y) == 0:
			# skip if the first cell is a background tile
			pass
		else:
			# make the current tile the correct sprite
			tilemap.set_cell(y_x.x, y, 0)
			# widen the corridor positive in x axis
			tilemap.set_cell(y_x.x + y_diff, y, 0)
			# make the cell 1 cell negative from current a wall cell
			tilemap.set_cell(y_x.x - y_diff, y, 0)
			# make the cell 2 cells positive from current a wall cell
