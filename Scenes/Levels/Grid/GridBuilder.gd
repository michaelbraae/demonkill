extends Node2D

# Chunk types
enum {
	QUAD,
	LEFT_RIGHT,
	TOP_DOWN
}

var INTERSECTION = preload('res://Scenes/Levels/Grid/Chunks/Intersection.tscn')
var HALL_HORIZONTAL = preload('res://Scenes/Levels/Grid/Chunks/HallHorizontal.tscn')
var HALL_VERTICAL = preload('res://Scenes/Levels/Grid/Chunks/HallVertical.tscn')

var CHUNKS = [
	{
		"type": QUAD,
		"scene": INTERSECTION,
		"weight": 1
	}
#	{
#		"type": LEFT_RIGHT,
#		"scene": HALL_HORIZONTAL,
#		"weight": 1
#	},
#	{
#		"type": TOP_DOWN,
#		"scene": HALL_HORIZONTAL,
#		"weight": 1
#	}
]

# how many grid chunks should be used to construct the grid
const DUNGEON_SIZE = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	buildGrid()

func buildGrid() -> void:
	var chunks_remaining = DUNGEON_SIZE
#	for i in chunks_remaining:
#	var chunk = CHUNKS[floor(rand_range(0, 2))]
	var chunk = CHUNKS[0]
	var instanced_chunk = chunk['scene'].instance()
	add_child(instanced_chunk)
	match chunk['type']:
		QUAD:
			for socket in instanced_chunk.get_node('Sockets').get_children():
				match socket.get_name():
					"Top":
						for j in CHUNKS:
							if [TOP_DOWN, QUAD].has(j['type']):
								var top_connected_chunk = j['scene'].instance()
								var new_chunk_position = (
									instanced_chunk.get_node('Sockets').get_node('Top').position
									+ (top_connected_chunk.position - top_connected_chunk.find_node('Bottom').position)
								)
								top_connected_chunk.position = new_chunk_position
								add_child(top_connected_chunk)
								#instance it and put it in place
					"Bottom":
						pass
					"Left":
						pass
					"Right":
						pass
					# for each socket, instance a new scene and position it correctly
				pass
		TOP_DOWN:
			pass
		LEFT_RIGHT:
			pass
