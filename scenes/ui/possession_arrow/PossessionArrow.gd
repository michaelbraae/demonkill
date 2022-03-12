extends Node2D

func _physics_process(_delta) -> void:
	look_at(to_global(get_local_mouse_position()))
