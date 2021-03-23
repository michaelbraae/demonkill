extends Node

var slowdown_timer

var slowdown_enabled = false

const MIN_SLOW = 0.12
const MEDIUM_SLOW = 0.15

func _ready():
	slowdown_timer = Timer.new()
	add_child(slowdown_timer)

func min_slowdown() -> void:
	if not slowdown_enabled:
		slowdown_enabled = true
		slowdown_timer.start(MIN_SLOW)
		Engine.time_scale = 0.1

func warp() -> void:
	if not slowdown_enabled:
		slowdown_enabled = true
		slowdown_timer.start(0.3)
		Engine.time_scale = 0.4

func slowdown(time : int = 0.5, scale : int = 0.5) -> void:
	if not slowdown_enabled:
		slowdown_enabled = true
		slowdown_timer.start(time)
		Engine.time_scale = scale

func _physics_process(_delta):
	if (
		not slowdown_timer.is_stopped() and
		slowdown_timer.get_time_left() < 0.1
	):
		slowdown_enabled = false
		slowdown_timer.stop()
		Engine.time_scale = 1

# handles game juice or game feel

# functions here should be invoked by other scripts causing game juicyness

# frame freeze for a split second to emphasis hits

# canvas layers causing black and white filters

# pulsating effect / zoom when drinking blood
