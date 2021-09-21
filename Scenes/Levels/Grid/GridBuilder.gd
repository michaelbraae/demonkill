extends Node2D

enum {
	QUAD,
	LEFT_RIGHT,
	TOP_DOWN
}

var INTERSECTION = preload('res://Scenes/Levels/Grid/Chunks/Intersection.tscn')
var HALL_HORIZONTAL = preload('res://Scenes/Levels/Grid/Chunks/HallHorizontal.tscn')
var HALL_VERTICAL = preload('res://Scenes/Levels/Grid/Chunks/HallVertical.tscn')

const CHUNKS = [
	{
		"type": QUAD,
		"scene": INTERSECTION,
		"weight": 1
	},
	{
		"path":""
	}
]

# how many grid chunks should be used to construct the grid
const DUNGEON_SIZE = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	buildGrid()
	pass # Replace with function body.

func buildGrid() -> void:
	for i in DUNGEON_SIZE:
		print(i)
