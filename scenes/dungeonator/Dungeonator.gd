tool
extends Node2D

export(bool) var build_dungeon setget trigger_dungeon_build

var min_spread_distance = 300
var max_spread_distance = 700

var TEST_START_ROOM = preload("res://scenes/dungeonator/rooms/1/StartRoom.tscn")
var TEST_ENCOUNTER = preload("res://scenes/encounter/encounters/TestEncounter.tscn")
var TEST_END_ROOM = preload("res://scenes/dungeonator/rooms/1/StartRoom.tscn")

var example_prefab = {
	"archetype": "dungeon-lower",
	"stage": 1,
	"rooms": {
		1: "encounter",
		2: "encounter",
		3: "hub",
		4: "shop",
		5: "encounter",
	},
}

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
	var new_angle = rand_range(current_angle - 45, current_angle + 45)
	return Vector2(cos(new_angle), sin(new_angle))

var crawler_position: Vector2

func make_rooms(prefab: Dictionary) -> void:
	# select a random spread direction
	
	var dungeon_spread = dungeon_spread_direction()
	# spawn the start room
	
	var start_room = TEST_START_ROOM.instance()
	$Rooms.add_child(start_room)
	
	var next_room_location = dungeon_spread * rand_range(min_spread_distance, max_spread_distance)
	crawler_position = next_room_location
	
	var current_angle
	
	for room in prefab["rooms"]:
		if prefab['rooms'][room] == "encounter":
			
			var next_room = TEST_ENCOUNTER.instance()
			$Rooms.add_child(next_room)
			
			next_room.position = crawler_position
			
			var last_position = crawler_position
			
			crawler_position += dungeon_spread * rand_range(min_spread_distance, max_spread_distance)
			
			dungeon_spread = new_dungeon_spread_direction(last_position, crawler_position)
		
		print(prefab['rooms'][room])
