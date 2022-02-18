extends Camera2D

var target_transform
var speed : float

#func _process(delta):
#	if target_transform:
#		set_global_position(
#			lerp(get_global_position(),
#				target_transform,
#				delta*speed
#			))
##	set_global_position( 
#		lerp(get_global_position(),
#			target_transform,
#			delta*speed
#		))
