extends "res://Resources/Scripts/NPC/CasterAI.gd"

func initialiseConfig() -> void:
	.initialiseConfig()
	setWaitTime(2)
	setAttackRange(350)
	setMoveSpeed(200)
	setRateOfFire(2)
	setMaxNumberOfAttacks(3)

func setProjectileScene() -> void:
	PROJECTILE_SCENE = preload("res://Resources/Projectiles/Energy-Ball/Energy-Ball.tscn")
