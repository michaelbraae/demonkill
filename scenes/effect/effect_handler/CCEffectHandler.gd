extends Node2D

class_name CCEffectHandler

# warning-ignore-all:unused_signal

signal stun_started
signal stun_finished

signal slow_started
signal slow_finished

signal freeze_started
signal freeze_finished

export(String, "stun_started", "slow_started", "freeze_started") var started_signal
export(String, "stun_finished", "slow_finished", "freeze_finished") var finished_signal

var effect_duration_timer: Timer

# to avoid stun locking, a timer is triggered when the CC effect 
var immunity_timer: Timer
onready var immunity_duration: float = get_parent().stun_immunity_duration

var is_stunned: bool = false

func _ready() -> void:
	effect_duration_timer = Timer.new()
	# warning-ignore:return_value_discarded
	effect_duration_timer.connect("timeout", self, "effect_duration_timeout")
	effect_duration_timer.one_shot = true
	add_child(effect_duration_timer)
	
	immunity_timer = Timer.new()
	immunity_timer.one_shot = true
	add_child(immunity_timer)

func begin_effect(effect: CCEffect) -> void:
	if effect_duration_timer.is_stopped() and immunity_timer.is_stopped():
		emit_signal(started_signal)
		initiate_cc_effect(effect.effect_duration)
		effect_duration_timer.start(effect.effect_duration)

func initiate_cc_effect(duration: float) -> void:
	get_parent().owner.stun(duration)

func effect_duration_timeout() -> void:
	emit_signal(finished_signal)
	# if duration is 0.0 ignore the immunity timer
	if immunity_duration:
		immunity_timer.start(immunity_duration)
