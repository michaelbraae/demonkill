extends RigidBody2D

var size

const FIREBALL_IMP_SCENE = preload("res://resources/actors/npc/imps/fireball_imp/FireballImp.tscn")
const SWIPE_IMP_SCENE = preload("res://resources/actors/npc/imps/flame_swipe_imp/FlameSwipeImp.tscn")
const ELITE_IMP_SCENE = preload("res://resources/actors/npc/imps/elite_imp/EliteImp.tscn")

# import enemy scene
# randomize which enemy to instantiate, place at _pos

var room_position

func make_room(_pos, _size):
	room_position = _pos
	position = _pos
	size = _size
	
	var s = RectangleShape2D.new()
	
	s.custom_solver_bias = 0.75
	s.extents = size
	$CollisionShape2D.shape = s

func spawnNpcs() -> void:
	var random_npc = rand_range(0, 1)
	var rand_npc
	if random_npc < 0.33:
		rand_npc = FIREBALL_IMP_SCENE.instance()
		rand_npc.position = room_position
		add_child(rand_npc)
	elif random_npc < 0.66:
		rand_npc = SWIPE_IMP_SCENE.instance()
		rand_npc.position = room_position
		add_child(rand_npc)
	else:
		rand_npc = ELITE_IMP_SCENE.instance()
		rand_npc.position = room_position
		add_child(rand_npc)
