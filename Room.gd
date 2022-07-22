extends RigidBody2D

var size

func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
#	s.custom_solver_bias = 0.75
	s.custom_solver_bias = 1
	s.extents = size
	$CollisionShape2D.shape = s
	$Area2D/CollisionShape2D.shape = s

func get_overlapping_rooms() -> Array:
#	var overlapping_rooms = []
#	for room in $Area2D.get_overlapping_areas():
##		if room.get_parent().is_in_group('Rooms'):
##			print('group found')
#		if room.get_parent().get_name() == "Room":
#			overlapping_rooms.push_front(room.get_parent())
#	return overlapping_rooms
	return $Area2D.get_overlapping_areas()
