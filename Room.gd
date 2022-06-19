extends RigidBody2D

var size

func make_room(_pos, _size):
	position = _pos
	size = _size
	
	# create several random enemies half way between center and edge
	var spawn_distance = _size / 4
	for i in 3:
		
		pass
	
	var s = RectangleShape2D.new()
	
	s.custom_solver_bias = 0.75
	s.extents = size
	$CollisionShape2D.shape = s
