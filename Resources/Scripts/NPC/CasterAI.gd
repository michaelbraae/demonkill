extends "res://Resources/Scripts/NPC/PossessableAI.gd"

var PROJECTILE_SCENE

var rate_of_fire
var max_number_of_attacks

var attack_range
var attacking = false
var attacks_fired = 0

# wait time before moving again
var targetting_timer
var before_attack_wait
var after_attack_wait
var rate_of_fire_timer

var before_attack_waiting = false
var after_attack_waiting = false

func _ready() -> void:
	setProjectileScene()
	initialiseConfig()

# configuration for setup
#	use this to set the setters
func initialiseConfig() -> void:
	targetting_timer = Timer.new()
	add_child(targetting_timer)
	rate_of_fire_timer = Timer.new()
	add_child(rate_of_fire_timer)

# set which projectile to use
func setProjectileScene() -> void:
	pass

# attacks per second to be fired
func setRateOfFire(rof : float) -> void:
	rate_of_fire = rof

func getRateOfFire() -> float:
	return rate_of_fire

# number of attacks in each "barrage"
func setMaxNumberOfAttacks(max_num : float) -> void:
	max_number_of_attacks = max_num

func getMaxNumberOfAttacks() -> float:
	return max_number_of_attacks

# when within this range, attack barrage will begin
func setAttackRange(range_var : float) -> void:
	attack_range = range_var

func getAttackRange() -> float:
	return attack_range

# the time to wait before the barrage before repositioning
#	could be considered the "time to aim"
func setBeforeAttackWait(b_a_w) -> void:
	before_attack_wait = b_a_w

func getBeforeAttackWait() -> float:
	return before_attack_wait

# the time to wait after the barrage before repositioning
#	could be considered the "time to reload"
func setAfterAttackWait(a_a_w) -> void:
	after_attack_wait = a_a_w

func getAfterAttackWait() -> float:
	return after_attack_wait

# true if the player is in the attack range
func isPlayerInRange() -> bool:
	var distance_to_player = get_global_position().distance_to(
		player.get_global_position()
	)
	if distance_to_player <= getAttackRange():
		return true
	return false

func attackThenWait() -> void:
	after_attack_waiting = true
	attackByRateOfFire()
	if targetting_timer.is_stopped() or targetting_timer.get_time_left() < 0.1:
		targetting_timer.start(getAfterAttackWait())

func attackByRateOfFire() -> void:
	if rate_of_fire_timer.is_stopped() or rate_of_fire_timer.get_time_left() <= 0.1:
		if attacks_fired < getMaxNumberOfAttacks():
			rate_of_fire_timer.start(1 / getRateOfFire())
			attack()
			attacks_fired += 1

# fires a projectile instance towards the player
func attack() -> void:
	var projectile_instance = PROJECTILE_SCENE.instance()
	get_parent().get_parent().add_child(projectile_instance)
	projectile_instance.setTargetId("IS_PLAYER")
	projectile_instance.set_global_position(get_global_position())
	projectile_instance.setTargetDirection(
		player.get_global_position() - get_global_position()
	)

# handles the decision making 
func handleNavigation() -> void:
	if player:
		alignRayCastToPlayer()
		detectBlockers()
		if after_attack_waiting and not path_blocked:
			attackThenWait()
		elif isPlayerInRange() and not path_blocked:
			attackThenWait()
		else:
			.handleNavigation()

func _process(_delta) -> void:
	if targetting_timer.get_time_left() < 0.1:
		after_attack_waiting = false
		attacks_fired = 0
