extends "res://Resources/Scripts/ProjectileBase.gd"

func _ready():
	setProjectileSpeed(5)
	setProjectileDamage(10)

func collisionEffect():
	print("IT WORKED!")
