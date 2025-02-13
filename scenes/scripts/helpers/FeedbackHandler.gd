extends Node

var slowdown_timer

var slowdown_enabled = false

var current_camera

const MIN_SLOW = 0.1
const MEDIUM_SLOW = 0.15

func _ready():
	slowdown_timer = Timer.new()
	slowdown_timer.connect('timeout', self, 'slowdown_timeout')
	add_child(slowdown_timer)

func shake_camera(duration: float = 0.2, intensity: float = 0.8) -> void:
	current_camera.shake(duration, intensity)

func vibrateController() -> void:
	Input.start_joy_vibration(0, 1, 1, 1)

func lightVibrate() -> void:
	Input.start_joy_vibration(0, 0, 0.3, 0.1)

func min_slowdown() -> void:
	if not slowdown_enabled:
		slowdown_enabled = true
		slowdown_timer.start(MIN_SLOW)
		Engine.time_scale = 0.5

func warp() -> void:
	if not slowdown_enabled:
		slowdown_enabled = true
		slowdown_timer.start(0.3)
		Engine.time_scale = 0.4

func slowdown(time : float = 0.5, scale : float = 0.5) -> void:
	if not slowdown_enabled:
		slowdown_enabled = true
		slowdown_timer.start(time)
		Engine.time_scale = scale

func slowdown_timeout() -> void:
	slowdown_enabled = false
	slowdown_timer.stop()
	Engine.time_scale = 1

# handles game juice or game feel

# functions here should be invoked by other scripts causing game juicyness

# frame freeze for a split second to emphasis hits - hit-stop

# canvas layers causing black and white filters

# pulsating effect / zoom when drinking blood
