extends Node

var BOLT_SCENE = preload('res://Resources/Abilities/Projectiles/Bolt/Bolt.tscn')

var ability_cool_down_timer
var ABILITY_COOL_DOWN = 2.0

# get current weapon from state

func fireProjectile(global_position : Vector2, attack_direction : Vector2) -> void:
	if ability_cool_down_timer.is_stopped():
		ability_cool_down_timer.start(ABILITY_COOL_DOWN)
		var bolt_instance = BOLT_SCENE.instance()
		get_parent().add_child(bolt_instance)
		bolt_instance.target_id = 'IS_ENEMY'
		bolt_instance.set_global_position(global_position)
		bolt_instance.target_direction = attack_direction
