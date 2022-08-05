extends Node2D

class_name CCEffectHandler

var effect_duration_timer: Timer

# to avoid stun locking, a timer is triggered when the CC effect 
var immunity_timer: Timer
onready var immunity_duration: float = get_parent().stun_immunity_duration

var is_stunned: bool = false

func _ready() -> void:
	effect_duration_timer = Timer.new()
	effect_duration_timer.connect("timeout", self, "effect_duration_timeout")
	effect_duration_timer.one_shot = true
	add_child(effect_duration_timer)
	
	immunity_timer = Timer.new()
	immunity_timer.one_shot = true
	add_child(immunity_timer)

func begin_effect(effect: StunEffect) -> void:
	if effect_duration_timer.is_stopped() and immunity_timer.is_stopped():
		initiate_cc_effect(effect.effect_duration)
		effect_duration_timer.start(effect.effect_duration)
		# if duration is 0.0 ignore the immunity timer

func initiate_cc_effect(duration: float) -> void:
	get_parent().owner.stun(duration)

func effect_duration_timeout() -> void:
	if immunity_duration:
		immunity_timer.start(immunity_duration)
