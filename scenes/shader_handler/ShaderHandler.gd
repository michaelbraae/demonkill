extends Node2D

# this script is responsible for switching between the various shaders that a game character might need

const POISON_SHADER = preload("res://assets/shaders/dot/Poison.tres")
const FLASH_SHADER = preload("res://assets/shaders/flash.gdshader")

func _ready() -> void:
	owner.get_node("EffectHandler/PoisonHandler").connect("poison_started", self, "poison_started")
	owner.get_node("EffectHandler/PoisonHandler").connect("poison_finished", self, "poison_finished")

func flash_shader() -> void:
	owner.animatedSprite.set_material(POISON_SHADER)

func clear_shaders() -> void:
	owner.animatedSprite.set_material(null)

func poison_started() -> void:
	owner.animatedSprite.set_material(POISON_SHADER)

func poison_finished() -> void:
	clear_shaders()
