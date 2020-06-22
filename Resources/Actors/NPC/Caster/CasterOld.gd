#extends "res://Resources/Scripts/NPC/AttackerAI.gd"
#
#var PROJECTILE_SCENE
#
#var rate_of_fire
#var max_number_of_attacks
#
#var attack_range
#var attacks_fired = 0
#
#var rate_of_fire_timer
#
#func initialiseConfig() -> void:
#	setProjectileScene()
#	rate_of_fire_timer = Timer.new()
#	add_child(rate_of_fire_timer)
#
#func setProjectileScene() -> void:
#	pass
#
#func setRateOfFire(rof : float) -> void:
#	rate_of_fire = rof
#
#func getRateOfFire() -> float:
#	return rate_of_fire
#
#func setMaxNumberOfAttacks(max_num : float) -> void:
#	max_number_of_attacks = max_num
#
#func getMaxNumberOfAttacks() -> float:
#	return max_number_of_attacks
#
#func setAttackRange(range_var : float) -> void:
#	attack_range = range_var
#
#func getAttackRange() -> float:
#	return attack_range
#
#func isPlayerInRange() -> bool:
#	var distance_to_player = get_global_position().distance_to(
#		player.get_global_position()
#	)
#	if distance_to_player <= getAttackRange():
#		return true
#	return false
#
#func attackByRateOfFire() -> void:
#	if rate_of_fire_timer.is_stopped() or rate_of_fire_timer.get_time_left() <= 0.1:
#		if attacks_fired < getMaxNumberOfAttacks():
#			rate_of_fire_timer.start(1 / getRateOfFire())
#			fireProjectile()
#			attacks_fired += 1
#		else:
#			attacks_fired = 0
#
#func fireProjectile() -> void:
#	var projectile_instance = PROJECTILE_SCENE.instance()
#	get_parent().get_parent().add_child(projectile_instance)
#	projectile_instance.setTargetId("IS_PLAYER")
#	projectile_instance.set_global_position(get_global_position())
#	projectile_instance.setTargetDirection(
#		player.get_global_position() - get_global_position()
#	)
#
#func runDecisionTree() -> void:
#	if getPlayer():
#		alignRayCastToPlayer()
#		detectBlockers()
#		if isPlayerInRange() and not path_blocked:
#			attackByRateOfFire()
#		else:
#			.runDecisionTree()
