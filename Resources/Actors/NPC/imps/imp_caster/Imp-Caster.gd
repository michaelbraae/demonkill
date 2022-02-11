extends CombatReadyAI

var SIMPLE_ENERGYBALL_SCENE = preload('res://resources/abilities/energy_ball/simple/SimpleEnergyBall.tscn')

func initialiseConfig():
	move_speed = 80
	attacks_in_sequence = 10
	repeat_attacks = true
	attack_range = 50
	attack_cooldown = 1
	complete_attack_sequence = true

func perAttackAction() -> void:
	var eball = SIMPLE_ENERGYBALL_SCENE.instance()
	get_parent().add_child(eball)
	var angle = get_angle_to(target_actor.get_global_position())
	eball.bang(Vector2(cos(angle), sin(angle)), self)
