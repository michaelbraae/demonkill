extends Node2D

# this script is responsible for switching between the various shaders that a game character might need

const POISON_SHADER = preload("res://assets/shaders/dot/poison/poison.tres")
const BURN_SHADER = preload("res://assets/shaders/dot/burn/burn.tres")
const FREEZE_SHADER = preload("res://assets/shaders/dot/freeze/freeze.tres")
const BLEED_SHADER = preload("res://assets/shaders/dot/bleed/bleed.tres")

const FLASH_SHADER = preload("res://assets/shaders/flash.gdshader")

# warning-ignore-all:return_value_discarded

func _ready() -> void:
	owner.get_node("EffectHandler/PoisonHandler").connect("poison_started", self, "poison_started")
	owner.get_node("EffectHandler/PoisonHandler").connect("poison_finished", self, "poison_finished")
	owner.get_node("EffectHandler/BurnHandler").connect("burn_started", self, "burn_started")
	owner.get_node("EffectHandler/BurnHandler").connect("burn_finished", self, "burn_finished")
	owner.get_node("EffectHandler/FreezeHandler").connect("freeze_started", self, "freeze_started")
	owner.get_node("EffectHandler/FreezeHandler").connect("freeze_finished", self, "freeze_finished")
	owner.get_node("EffectHandler/BleedHandler").connect("bleed_started", self, "bleed_started")
	owner.get_node("EffectHandler/BleedHandler").connect("bleed_finished", self, "bleed_finished")

func flash_shader() -> void:
	owner.animatedSprite.set_material(POISON_SHADER)

func clear_shaders() -> void:
	owner.animatedSprite.set_material(null)

func poison_started() -> void:
	owner.animatedSprite.set_material(POISON_SHADER)

func poison_finished() -> void:
	clear_shaders()

func burn_started() -> void:
	owner.animatedSprite.set_material(BURN_SHADER)

func burn_finished() -> void:
	clear_shaders()

func freeze_started() -> void:
	owner.animatedSprite.set_material(FREEZE_SHADER)

func freeze_finished() -> void:
	clear_shaders()

func bleed_started() -> void:
	owner.animatedSprite.set_material(BLEED_SHADER)

func bleed_finished() -> void:
	clear_shaders()
