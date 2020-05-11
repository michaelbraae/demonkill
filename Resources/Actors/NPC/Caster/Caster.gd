extends "res://Resources/Scripts/NPC/PossessableAI.gd"

var ENERGY_BALL_SCENE = preload("res://Resources/Projectiles/Energy-Ball/Energy-Ball.tscn")

var rate_of_fire
var max_number_of_attacks

var attack_range
var attacking = false
var attacks_fired = 0

var targetting_timer
var target_time
var rate_of_fire_timer

func _ready() -> void:
	initialiseConfig()

func initialiseConfig() -> void:
	setTargetTime(1)
	targetting_timer = Timer.new()
	add_child(targetting_timer)
	rate_of_fire_timer = Timer.new()
	add_child(rate_of_fire_timer)
	setAttackRange(250)
	setMoveSpeed(200)
	setRateOfFire(3)
	setMaxNumberOfAttacks(2)

func setRateOfFire(rof : float) -> void:
	rate_of_fire = rof

func getRateOfFire() -> float:
	return rate_of_fire

func setMaxNumberOfAttacks(max_num : float) -> void:
	max_number_of_attacks = max_num

func getMaxNumberOfAttacks() -> float:
	return max_number_of_attacks

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

func attackByRateOfFire() -> void:
	if rate_of_fire_timer.is_stopped() or rate_of_fire_timer.get_time_left() <= 0.1:
		if attacks_fired < getMaxNumberOfAttacks():
			var fire_rate = 1 / getRateOfFire()
			rate_of_fire_timer.start(fire_rate)
			attack()
			attacks_fired += 1

func attack() -> void:
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
			if isPlayerInRange() and targetting_timer.is_stopped():
				attackByRateOfFire()
			else:
				.handleNavigation()

func _process(_delta):
	if targetting_timer.get_time_left() < 0.2:
		targetting_timer.stop()
		attacking = false
