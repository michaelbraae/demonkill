extends RigidBody2D

var size

func make_room(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = 1 #0.75 was the original but not sure what it means
	s.extents = size
	$CollisionShape2D.shape = s
	$Area2D/CollisionShape2D.shape = s

func get_overlapping_rooms() -> Array:
	return $Area2D.get_overlapping_areas()
