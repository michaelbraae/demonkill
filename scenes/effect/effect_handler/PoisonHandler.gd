extends Node2D

var is_poisoned: bool = false

var stacks: int = 0

var effect_duration_timer: Timer

var tick_timer: Timer

var effect_duration: float
var effect_damage: int
var effect_tick_rate: float

# warning-ignore-all:return_value_discarded

func _ready() -> void:
	effect_duration_timer = Timer.new()
	effect_duration_timer.connect("timeout", self, "effect_duration_timeout")
	effect_duration_timer.one_shot = true 
	add_child(effect_duration_timer)
	
	tick_timer = Timer.new()
	tick_timer.connect("timeout", self, "tick_timeout")
	add_child(tick_timer)

func effect_duration_timeout() -> void:
	stacks -= 1
	if stacks:
		effect_duration_timer.start(effect_duration)
	else:
		get_parent().owner.get_node("ShaderHandler").clear_shaders()
		tick_timer.stop()

func tick_timeout() -> void:
	get_parent().owner.damage(effect_damage * stacks)

func beginEffect(effect: PoisonEffect) -> void:
	get_parent().owner.get_node("ShaderHandler").poison_shader()
	effect_duration = effect.effect_duration
	effect_tick_rate = effect.tick_rate
	effect_damage = effect.damage
	stacks += 1
	effect_duration_timer.start(effect_duration)
	tick_timer.start(effect_tick_rate)
	
	# add the poison shader
	
	# check to see if the player is Already poisoned
	
	# create a new stack of Poison, the poison duration should be variable
	
	# the tick rate should incur a poison damage each tick
	
	# the poison damage should be variable
