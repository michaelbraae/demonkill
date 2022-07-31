extends Node2D

# this script is responsible for switching between the various shaders that a game character might need

const POISON_SHADER = preload("res://assets/shaders/dot/Poison.tres")
const FLASH_SHADER = preload("res://assets/shaders/flash.gdshader")

func clear_shaders() -> void:
	owner.animatedSprite.set_material(null)

func poison_shader() -> void:
	owner.animatedSprite.set_material(POISON_SHADER)
