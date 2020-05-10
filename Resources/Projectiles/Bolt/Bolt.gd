extends "res://Resources/Scripts/ProjectileBase.gd"

func initialiseConfig():
	setProjectileSpeed(10)
	setProjectileDamage(1)
	setTargetId("IS_ENEMY")

#func collisionEffect():
#   knock back and pin to walls
#	print("IT WORKED!")
