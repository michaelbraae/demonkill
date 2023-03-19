tool
extends Node2D

export(bool) var build_dungeon setget trigger_dungeon_build


var room_size = 100

var font = preload("res://assets/RobotoBold120.tres")

var TEST_START_ROOM = preload("res://scenes/dungeonator/rooms/1/StartRoom.tscn")
var TEST_ENCOUNTER = preload("res://scenes/encounter/encounters/TestEncounter.tscn")
var TEST_END_ROOM = preload("res://scenes/dungeonator/rooms/1/StartRoom.tscn")

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

const PATH_BEGIN = 1
const PATH_END = 2

# no room can be within an area of this size near another room
const ROOM_NO_SPAWN_ZONE_SIZE = 1500

onready var Map: TileMap = $TileMap

func trigger_dungeon_build(value):
	if value:
		make_rooms(example_prefab)

func dungeon_spread_direction() -> Vector2:
   var new_dir: = Vector2()
   new_dir.x = rand_range(-1, 1)
   new_dir.y = rand_range(-1, 1)
   return new_dir.normalized()

func new_dungeon_spread_direction(last_position: Vector2, current_direction: Vector2) -> Vector2:
	var current_angle = last_position.angle_to(current_direction)
	
	# Choose a random angle that deviates from the current direction
	var max_angle_deviation = 15
	var new_angle = rand_range(current_angle - max_angle_deviation, current_angle + max_angle_deviation)
	
	# Convert the angle back to a direction vector
	return Vector2(cos(new_angle), sin(new_angle))

var crawler_position: Vector2


var path_begin: Position2D
var path_end: Position2D
var current_direction = Vector2()

func make_rooms(prefab: Dictionary) -> void:
	# spawn the start room
	var start_room = TEST_START_ROOM.instance()
	$Rooms.add_child(start_room)
	
	var crawler_position = start_room.position
	
	# Initialize variables to keep track of closest Position2d nodes
	var closest_to_prev_room: Position2D = null
	var closest_to_next_room: Position2D = null
	var closest_distance_to_prev_room = 0
	var closest_distance_to_next_room = 0
	
	for room in prefab["rooms"]:
		if prefab['rooms'][room] == "encounter":
			var next_room = TEST_ENCOUNTER.instance()
			$Rooms.add_child(next_room)
			current_direction = next_room.position
			
			# Choose a new direction that deviates from the current direction
			var new_direction = new_dungeon_spread_direction(crawler_position, current_direction)
			current_direction = new_direction
			
			# Calculate the position of the next room using the new direction
			var next_room_location = crawler_position + new_direction * 500
			next_room.position = next_room_location
			
			# Find the closest Position2D node to the previous and next rooms
			var doors = next_room.get_node("Doors")
			for i in range(doors.get_child_count()):
				var door = doors.get_child(i)
				var door_distance_to_prev_room = door.global_position.distance_to(start_room.global_position)
				var door_distance_to_next_room = door.global_position.distance_to(next_room.global_position)
				if door_distance_to_prev_room < closest_distance_to_prev_room:
					closest_distance_to_prev_room = door_distance_to_prev_room
					closest_to_prev_room = door
				if door_distance_to_next_room < closest_distance_to_next_room:
					closest_distance_to_next_room = door_distance_to_next_room
					closest_to_next_room = door
			
			# Set the flags indicating which Position2D node is closest to the previous and next rooms
			if closest_to_prev_room:
				closest_to_prev_room.set_meta("position", PATH_END)
			if closest_to_next_room:
				closest_to_next_room.set_meta("position", PATH_BEGIN)
			
			draw_string(font, next_room.position-Vector2(125,0), prefab['rooms'][room], Color(1,1,1))
			
			crawler_position = next_room_location
		
		print(prefab['rooms'][room])

	# spawn the end room
	var end_room = TEST_END_ROOM.instance()
	$Rooms.add_child(end_room)
	end_room.position = crawler_position
	
	# Find the closest Position2D node in the end room to the previous room
	var end_doors = end_room.get_node("Doors")
	var closest_distance_to_prev_room_end = 0
	var closest_to_prev_room_end: Position2D = null
	for i in range(end_doors.get_child_count()):
		var door = end_doors.get_child(i)
		var door_distance_to_prev_room = door.global_position.distance_to(start_room.global_position)
		if door_distance_to_prev_room < closest_distance_to_prev_room_end:
			closest_distance_to_prev_room_end = door_distance_to_prev_room
			closest_to_prev_room_end = door
		
	# Set the flag indicating which Position2D node in the end room is closest to the previous room
	if closest_to_prev_room_end:
		closest_to_prev_room_end.set_meta("position", PATH_END)

func connect_room_paths() -> void:
	# get the current rooms path_begin
	# get the next rooms path_eng
	# carve the path
	# move to the next room
	pass

func carve_path(pos1, pos2):
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
		if Map.get_cell(x, x_y.y) == 0:
			pass
		else:
			# make the current tile the correct sprite
			Map.set_cell(x, x_y.y, 0)
			# widen the corridor both ways in y axis
			Map.set_cell(x, x_y.y + y_diff, 0)
			Map.set_cell(x, x_y.y - y_diff, 0)
			
	for y in range(pos1.y, pos2.y, y_diff):
		if Map.get_cell(y_x.x, y) == 0:
			# skip if the first cell is a background tile
			pass
		else:
			# make the current tile the correct sprite
			Map.set_cell(y_x.x, y, 0)
			# widen the corridor positive in x axis
			Map.set_cell(y_x.x + y_diff, y, 0)
			# make the cell 1 cell negative from current a wall cell
			Map.set_cell(y_x.x - y_diff, y, 0)
			# make the cell 2 cells positive from current a wall cell
