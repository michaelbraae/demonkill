extends Node2D

var stacks: int = 0

var effect_duration_timer: Timer

var tick_timer: Timer

var effect_duration: float
var effect_damage: int
var effect_tick_rate: float

signal poison_started
signal poison_finished

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
		tick_timer.stop()
		emit_signal("poison_finished")

func tick_timeout() -> void:
	get_parent().owner.damage(effect_damage * stacks)

func beginEffect(effect: PoisonEffect) -> void:
	emit_signal("poison_started")
	stacks += 1
	
	effect_duration = effect.effect_duration
	effect_tick_rate = effect.tick_rate
	effect_damage = effect.damage
	
	effect_duration_timer.start(effect_duration)
	tick_timer.start(effect_tick_rate)
