extends Node2D

class_name DOTEffectHandler

var stacks: int = 0

var effect_duration_timer: Timer

var tick_timer: Timer

var effect_duration: float
var effect_damage: int
var effect_tick_rate: float

# warning-ignore-all:unused_signal

signal poison_started
signal poison_finished

signal burn_started
signal burn_finished

signal freeze_started
signal freeze_finished

export(String, "poison_started", "burn_started", "freeze_started") var started_signal
export(String, "poison_finished", "burn_finished", "freeze_finished") var finished_signal

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
		emit_signal(finished_signal)

func tick_timeout() -> void:
	get_parent().owner.damage(effect_damage * stacks)

func begin_effect(effect: DotEffect) -> void:
	emit_signal(started_signal)
	stacks += 1
	
	effect_duration = effect.effect_duration
	effect_tick_rate = effect.tick_rate
	effect_damage = effect.damage
	
	effect_duration_timer.start(effect_duration)
	tick_timer.start(effect_tick_rate)
