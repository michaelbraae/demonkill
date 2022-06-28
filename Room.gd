extends RigidBody2D

var size

func make_room(_pos, _size):
	
	add_to_group("Rooms")
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = 0.75
	s.extents = size
	$CollisionShape2D.shape = s
	$Area2D/CollisionShape2D.shape = s

func getOverlappingRooms() -> Array:
	var overlapping_rooms = []
	for room in $Area2D.get_overlapping_areas():
		if room.get_parent().is_in_group('Rooms'):
			print('group found')
			overlapping_rooms.push_front(room.get_parent())
	return overlapping_rooms
