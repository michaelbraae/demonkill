extends "res://Resources/Scripts/NPC/PossessableAI.gd"

var ENERGY_BALL_SCENE = preload("res://Resources/Projectiles/Energy-Ball/Energy-Ball.tscn")

var attacks_per_second
var number_of_attacks

var attack_range
var attacking = false

var targetting_timer
var target_time

func _ready() -> void:
	initialiseConfig()

func initialiseConfig() -> void:
	setTargetTime(1)
	targetting_timer = Timer.new()
	add_child(targetting_timer)
	setAttackRange(200)
	setMoveSpeed(200)
	setAttacksPerSecond(3)

func setAttacksPerSecond(aps : float) -> void:
	attacks_per_second = aps

func getAttacksPerSecond() -> float:
	return attacks_per_second

func setNumberOfAttacks(noa : float) -> void:
	number_of_attacks = noa

func getNumberOfAttacks() -> float:
	return number_of_attacks

func setAttackRange(range_var : float) -> void:
	attack_range = range_var
	
func getAttackRange() -> float:
	return attack_range

func setTargetTime(target_time_var : float) -> void:
	target_time = target_time_var

func getTargetTime() -> float:
	return target_time

func isPlayerInRange() -> bool:
	var distance_to_player = get_global_position().distance_to(
		player.get_global_position()
	)
	if distance_to_player <= getAttackRange():
		return true
	return false

func attack() -> void:
	targetting_timer.start(getTargetTime())
	attacking = true
	var eball_instance = ENERGY_BALL_SCENE.instance()
	get_parent().get_parent().add_child(eball_instance)
	eball_instance.setTargetId("IS_PLAYER")
	eball_instance.set_global_position(get_global_position())
	eball_instance.setTargetDirection(
		player.get_global_position() - get_global_position()
	)

func handleNavigation() -> void:
	if player and not attacking:
		detectBlockers()
		if path_blocked:
			.handleNavigation()
		else:
			if isPlayerInRange():
				attack()
			else:
				.handleNavigation()

func _process(_delta):
	if targetting_timer.get_time_left() < 0.2:
		targetting_timer.stop()
		attacking = false
