extends Node2D

var Room = preload("res://Room.tscn")
var PLAYER_SCENE = preload("res://scenes/character/player/Player.tscn")
var font = preload("res://assets/RobotoBold120.tres")
onready var Map: TileMap = $TileMap

# npc scenes
const FIREBALL_IMP_SCENE = preload("res://resources/actors/npc/imps/fireball_imp/FireballImp.tscn")
const SWIPE_IMP_SCENE = preload("res://resources/actors/npc/imps/flame_swipe_imp/FlameSwipeImp.tscn")
const ELITE_IMP_SCENE = preload("res://resources/actors/npc/imps/elite_imp/EliteImp.tscn")
const FREEZE_IMP_SCENE = preload("res://scenes/character/npc/freeze_imp/FreezeImp.tscn")
const FIREBALL_IMP = preload("res://scenes/character/npc/fireball_imp/FireballImp.tscn")

var tile_size = 16  # size of a tile in the TileMap
var num_rooms = 15  # number of rooms to generate - 50
var min_size = 8  # minimum room size (in tiles) - 6 
var max_size = 12  # maximum room size (in tiles) - 16
var hspread = 400  # horizontal spread (in pixels) - 400
var vspread = 400
var cull = 0.35  # chance to cull room - 0.35

var path  # AStar pathfinding object
var start_room = null
var end_room = null
var play_mode = false
var player = null

var ready_for_tilemap = false
var ready_for_player = false

var room_positions = []

func _ready():
	GameState.tilemap = $TileMap
	randomize()
	make_rooms()

func make_rooms():
	for _i in range(num_rooms):
		var pos = Vector2(rand_range(-hspread, hspread), rand_range(-vspread, vspread))
		var r = Room.instance()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(r)
	# wait for movement to stop
	yield(get_tree().create_timer(1.1), 'timeout')
	# cull rooms
	for room in $Rooms.get_children():
#		var overlapping_rooms = room.getOverlappingRooms()
#		if overlapping_rooms:
#			for overlapping_room in overlapping_rooms:
#				overlapping_room.queue_free()
		if randf() < cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(Vector3(room.position.x, room.position.y, 0))
	yield(get_tree(), 'idle_frame')
	# generate a minimum spanning tree connecting the rooms
	path = find_mst(room_positions)

func _draw():
	if start_room:
		draw_string(font, start_room.position-Vector2(125,0), "start", Color(1,1,1))
	if is_instance_valid(end_room):
		draw_string(font, end_room.position-Vector2(125,0), "end", Color(1,1,1))
	if play_mode:
		return
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2),
				 Color(0, 1, 0), false)
	if path:
		for p in path.get_points():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y),
						  Color(1, 1, 0), 15, true)

func _process(_delta):
	update()

func _input(event):
	if event.is_action_pressed('dungeon_generate_structure'):
		if play_mode:
			if is_instance_valid(player):
				player.queue_free()
			$Camera2D.make_current()
			play_mode = false
		for n in $Rooms.get_children():
			n.queue_free()
		Map.clear()
		path = null
		start_room = null
		end_room = null
		make_rooms()
	if event.is_action_pressed('dungeon_make_map') and ready_for_tilemap:
		ready_for_tilemap = false
		make_map()
	if event.is_action_pressed('dungeon_add_player') and ready_for_player:
		ready_for_player = false
		player = PLAYER_SCENE.instance()
		add_child(player)
		GameState.state = GameState.CONTROLLING_PLAYER
		GameState.player = player
		if is_instance_valid(start_room):
			player.position = start_room.position
		play_mode = true

func find_mst(nodes):
	# Prim's algorithm
	# Given an array of positions (nodes), generates a minimum
	# spanning tree
	# Returns an AStar object
	
	# Initialize the AStar and add the first point
	path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	# Repeat until no more nodes remain
	while nodes:
		var min_dist = INF  # Minimum distance so far
		var min_p = null  # Position of that node
		var p = null  # Current position
		# Loop through points in path
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			# Loop through the remaining nodes
			for p2 in nodes:
				# If the node is closer, make it the closest
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1
		# Insert the resulting node into the path and add
		# its connection
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		# Remove the node from the array so it isn't visited again
		nodes.erase(min_p)
	ready_for_tilemap = true
	return path

func make_map():
	# Create a TileMap from the generated rooms and path
	Map.clear()
	find_start_room()
	find_end_room()
	
	# Carve rooms
	var corridors = []  # One corridor per connection
	for room in $Rooms.get_children():
		room.get_node('CollisionShape2D').queue_free()
		var s = (room.size / tile_size).floor()
#		var pos = Map.world_to_map(room.position)
		var ul = (room.position / tile_size).floor() - s
		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):
				Map.set_cell(ul.x + x, ul.y + y, 0)
	
		# Carve connecting corridor
		var p = path.get_closest_point(Vector3(room.position.x, room.position.y, 0))
		
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.world_to_map(Vector2(path.get_point_position(p).x,
													path.get_point_position(p).y))
				var end = Map.world_to_map(Vector2(path.get_point_position(conn).x,
													path.get_point_position(conn).y))
				carve_path(start, end)
		corridors.append(p)
	# iterate over each tile in the tilemap, if it has a tile present, check all four sides
	# if ANY sides are empty, add a wall
	for floor_cell in Map.get_used_cells_by_id(0):
		if Map.get_cell(floor_cell.x + 1, floor_cell.y) == -1:
			Map.set_cell(floor_cell.x + 1, floor_cell.y, 1)
		if Map.get_cell(floor_cell.x - 1, floor_cell.y) == -1:
			Map.set_cell(floor_cell.x - 1, floor_cell.y, 1)
		if Map.get_cell(floor_cell.x, floor_cell.y + 1) == -1:
			Map.set_cell(floor_cell.x, floor_cell.y + 1, 1)
		if Map.get_cell(floor_cell.x, floor_cell.y - 1) == -1:
			Map.set_cell(floor_cell.x, floor_cell.y - 1, 1)
	
	buildAStarNavigation()
	connectAStarNavPoints()
	
	# iterate over the rooms and add npcs to each
#	add_npcs()
	add_test_npc()
	ready_for_player = true

var cell_coords = []

func buildAStarNavigation() -> void:
	var used_cells = $TileMap.get_used_cells_by_id(0)
	var count = 0
	for cell in used_cells:
		var new_cell_coord = {
			"id": count,
			"cell": cell
		}
		cell_coords.push_back(new_cell_coord)
		count += 1
		GameState.astar.add_point(new_cell_coord["id"], $TileMap.map_to_world(new_cell_coord["cell"]))

func findCellFromCoordinates(cell) -> Dictionary:
	for tile_cell in cell_coords:
		if cell == tile_cell["cell"]:
			return tile_cell
	return {}

func connectAStarNavPoints() -> void:
	var used_cells = $TileMap.get_used_cells_by_id(0)
	for cell in used_cells:
		# RIGHT, LEFT, DOWN, UP
		var neighbors = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]
		for neighbor in neighbors:
			var next_cell = cell + neighbor
			if used_cells.has(next_cell):
				GameState.astar.connect_points(
					findCellFromCoordinates(cell)["id"],
					findCellFromCoordinates(next_cell)["id"]
				)

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

func find_start_room():
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x

func find_end_room():
	var max_x = -INF
	for room in $Rooms.get_children():
		if room.position.x > max_x:
			end_room = room
			max_x = room.position.x

func add_test_npc() -> void:
#	var npc = FIREBALL_IMP.instance()
	var npc = FREEZE_IMP_SCENE.instance()
	npc.set_position(start_room.get_position())
	add_child(npc)

func add_npcs() -> void:
	for room in $Rooms.get_children():
		if room != start_room:
			spawnNpcs(room.get_position())

func spawnNpcs(spawn_origin) -> void:
	for i in 3:
		var random_npc = rand_range(0, 1)
		var rand_npc
		spawn_origin.x += i * 15
		if random_npc < 0.33:
			rand_npc = FIREBALL_IMP_SCENE.instance()
			rand_npc.position = spawn_origin
			add_child(rand_npc)
		elif random_npc < 0.66:
			rand_npc = SWIPE_IMP_SCENE.instance()
			rand_npc.position = spawn_origin
			add_child(rand_npc)
		else:
			rand_npc = FREEZE_IMP_SCENE.instance()
			rand_npc.position = spawn_origin
			add_child(rand_npc)
