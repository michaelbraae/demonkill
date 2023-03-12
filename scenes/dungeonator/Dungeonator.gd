tool
extends Node2D

# reads the prefab

# spawns the rooms in a vague direction in the order defined by the prefab

# carves the path from one room to the next

# prefabs should be categorized into level archetypes and stage

# level represents the dungeon tileset / style

# stage represents the stage of that particular tileset / style

# ie: grass tileset may have 2 stages and a boss etc

# so a prefab has a defined structure and 2 values. archetype and stage

# shops will always have the same tileset, to remain consistent between stages

# boss rooms are pre-defined by hand

# but are loaded in by the player using the boss door

# all prefabs have a start and end room

# all paths between rooms are the same size

# but tileset will change based on the archetype

export(bool) var build_dungeon setget trigger_dungeon_build

var min_spread_distance = 500
var max_spread_distance = 1000

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

var crawler_position: Vector2

func make_rooms(prefab: Dictionary) -> void:
	# select a random spread direction
	
	var dungeon_spread = dungeon_spread_direction()
	# spawn the start roo
	
	var start_room = TEST_START_ROOM.instance()
	$Rooms.add_child(start_room)
	
	var next_room_location = dungeon_spread * rand_range(min_spread_distance, max_spread_distance)
	crawler_position = next_room_location
	
	for room in prefab["rooms"]:
		if prefab['rooms'][room] == "encounter":
			var next_room = TEST_ENCOUNTER.instance()
			$Rooms.add_child(next_room)
			next_room.position = crawler_position
			crawler_position += dungeon_spread * rand_range(min_spread_distance, max_spread_distance)
		print(prefab['rooms'][room])
