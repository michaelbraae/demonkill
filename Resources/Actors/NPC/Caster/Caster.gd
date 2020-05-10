extends "res://Resources/Scripts/NPC/PossessableAI.gd"

var ENERGY_BALL_SCENE = preload("res://Resources/Projectiles/Energy-Ball/Energy-Ball.tscn")

var attack_range
var attacking = false

func _ready():
	setAttackRange(200)
	setMoveSpeed(200)

func setAttackRange(range_var : float):
	attack_range = range_var
	
func getAttackRange():
	return attack_range

func isPlayerInRange() -> bool:
	var distance_to_player = get_global_position().distance_to(
		player.get_global_position()
	)
	if distance_to_player <= getAttackRange():
		return true
	return false

func attack() -> void:
	attacking = true

func handleNavigation():
	if player:
		detectBlockers()
		if path_blocked:
			.handleNavigation()
		else:
			if isPlayerInRange():
				attack()
			else:
				.handleNavigation()
