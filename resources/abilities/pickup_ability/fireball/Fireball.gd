extends KinematicBody2D

var target_vector : Vector2
var projectile_speed : int = 150 #300

var WHITE_IMPACT = preload('res://resources/effects/impacts/white_impact/WhiteImpact.tscn')


func setCollideWithEnemies() -> void:
	set_collision_mask(4)
	set_collision_layer(4)
#	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)

func setCollideWithPlayer() -> void:
	set_collision_mask(2)
	set_collision_layer(2)
#	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)

func _physics_process(delta):
	var collision = move_and_collide(target_vector * projectile_speed * delta)
	if collision:
		var impact_instance = WHITE_IMPACT.instance()
		if collision.get_collider().has_method("damage"):
			collision.get_collider().damage(2)
		if collision.get_collider().has_method("knockBack"):
			collision.get_collider().knockBack(target_vector.angle(), 150, 15)
		get_tree().get_root().add_child(impact_instance)
		impact_instance.position = position
		impact_instance.play()
		queue_free()

