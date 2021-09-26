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
	},
	{
		"type": LEFT_RIGHT,
		"scene": HALL_HORIZONTAL,
		"weight": 1
	},
	{
		"type": TOP_DOWN,
		"scene": HALL_VERTICAL,
		"weight": 1
	}
]

# how many grid chunks should be used to construct the grid
const DUNGEON_SIZE = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	buildGrid()

func addNewChunk(parent_scene, scene, parent_socket, child_socket) -> void:
	var top_connected_chunk = scene
	var new_chunk_position = (
		parent_scene.get_node('Sockets').get_node(parent_socket).position
		+ (top_connected_chunk.position - top_connected_chunk.find_node(child_socket).position)
	)
	top_connected_chunk.position = new_chunk_position
	$Grid.add_child(top_connected_chunk)

func buildGrid() -> void:
	var chunks_remaining = DUNGEON_SIZE
	randomize()
	var chunk = CHUNKS[floor(rand_range(0, CHUNKS.size()))]
	var instanced_chunk = chunk['scene'].instance()
	$Grid.add_child(instanced_chunk)
	
	match chunk['type']:
		QUAD:
			for socket in instanced_chunk.get_node('Sockets').get_children():
				match socket.get_name():
					"Top":
						for j in CHUNKS:
							if [TOP_DOWN, QUAD].has(j['type']):
								addNewChunk(instanced_chunk, j['scene'].instance(), 'Top', 'Bottom')
					"Bottom":
						for j in CHUNKS:
							if [TOP_DOWN, QUAD].has(j['type']):
								addNewChunk(instanced_chunk, j['scene'].instance(), 'Bottom', 'Top')
					"Left":
						for j in CHUNKS:
							if [LEFT_RIGHT, QUAD].has(j['type']):
								addNewChunk(instanced_chunk, j['scene'].instance(), 'Left', 'Right')
					"Right":
						for j in CHUNKS:
							if [LEFT_RIGHT, QUAD].has(j['type']):
								addNewChunk(instanced_chunk, j['scene'].instance(), 'Right', 'Left')
					# for each socket, instance a new scene and position it correctly
		TOP_DOWN:
			for socket in instanced_chunk.get_node('Sockets').get_children():
				match socket.get_name():
					"Top":
						for j in CHUNKS:
							if [TOP_DOWN, QUAD].has(j['type']):
								addNewChunk(instanced_chunk, j['scene'].instance(), 'Top', 'Bottom')
					"Bottom":
						for j in CHUNKS:
							if [TOP_DOWN, QUAD].has(j['type']):
								addNewChunk(instanced_chunk, j['scene'].instance(), 'Bottom', 'Top')
		LEFT_RIGHT:
			for socket in instanced_chunk.get_node('Sockets').get_children():
				match socket.get_name():
					"Left":
						for j in CHUNKS:
							if [LEFT_RIGHT, QUAD].has(j['type']):
								addNewChunk(instanced_chunk, j['scene'].instance(), 'Left', 'Right')
					"Right":
						for j in CHUNKS:
							if [LEFT_RIGHT, QUAD].has(j['type']):
								addNewChunk(instanced_chunk, j['scene'].instance(), 'Right', 'Left')
