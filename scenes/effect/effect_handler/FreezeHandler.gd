extends DOTEffectHandler

var freeze_immunity_timer: Timer

export var freeze_immunity_duration: float = 2.0

# warning-ignore-all:return_value_discarded

onready var is_player = PossessionState.is_player(get_parent().owner)

func _ready() -> void:
	freeze_immunity_timer = Timer.new()
	freeze_immunity_timer.one_shot = true
	freeze_immunity_timer.connect("timeout", self, "freeze_immunity_timeout")
	add_child(freeze_immunity_timer)

func begin_effect(effect: DotEffect) -> void:
	if stacks < 1:
		print("begin_effect, handler is player: ", is_player)
		if is_player and freeze_immunity_timer.is_stopped():
			initiate_freeze(effect)
		elif !is_player:
			initiate_freeze(effect)

# it's really toxic if you keep getting chain frozen, so i-frames
func freeze_immunity_timeout() -> void:
	freeze_immunity_timer.stop()

func effect_duration_timeout() -> void:
	stacks -= 1
	if (
		PossessionState.is_player(get_parent().owner)
		and freeze_immunity_timer.is_stopped()
	):
		freeze_immunity_timer.start(freeze_immunity_duration)
	emit_signal(finished_signal)

func initiate_freeze(effect: DotEffect) -> void:
	stacks += 1
	effect_duration_timer.start(effect.effect_duration)
#	get_parent().owner.freeze(effect.effect_duration)
	emit_signal(started_signal)
