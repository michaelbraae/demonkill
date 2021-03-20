extends KinematicBody2D

onready var path_follow = get_parent()

const INTERACTABLE = true
const POSSESSABLE = true
var path = []
var path_ind = 0
const move_speed = 100
var move_direction = 0

#func _physics_process(delta):
#	if Input.is_action_just_pressed('click_left'):
#		move_to(Vector2(64, -320))
#	if path_ind < path.size():
#		var move_vec = (path[path_ind] - global_transform.origin)
#		if move_vec.length() < 0.1:
#			path_ind += 1
#		else:
#			move_and_slide(move_vec.normalized() * move_speed)
#
#func move_to(target_pos):
#	path = nav.get_simple_path(global_transform.origin, target_pos)
#	path_ind = 0
