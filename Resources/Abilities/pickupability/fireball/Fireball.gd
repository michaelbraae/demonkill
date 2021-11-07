extends KinematicBody2D

var target_vector : Vector2
var projectile_speed : int = 300

var WHITE_IMPACT = preload('res://Resources/Effects/Impacts/WhiteImpact/WhiteImpact.tscn')

func setCollideWithEnemies() -> void:
	set_collision_mask(4)
	set_collision_layer(4)

func setCollideWithPlayer() -> void:
	set_collision_mask(2)
	set_collision_layer(2)

func _physics_process(delta):
	var collision = move_and_collide(target_vector * projectile_speed * delta)
	if collision:
		var impact_instance = WHITE_IMPACT.instance()
		get_tree().get_root().add_child(impact_instance)
		impact_instance.position = position
		impact_instance.play()
		queue_free()

