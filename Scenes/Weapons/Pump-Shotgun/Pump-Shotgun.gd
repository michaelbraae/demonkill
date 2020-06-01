extends WeaponRotation

var ENERGY_BALL_SCENE = preload("res://Resources/Abilities/Projectiles/Energy-Ball/Energy-Ball.tscn")

func fire(attack_direction : Vector2) -> void:
	var bullet_instance = ENERGY_BALL_SCENE.instance()
	get_parent().add_child(bullet_instance)
	bullet_instance.setTargetId("IS_ENEMY")
	bullet_instance.set_position(muzzle.get_position())
	bullet_instance.setTargetDirection(attack_direction)
