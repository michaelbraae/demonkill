extends Camera2D

var shake_amount = 2 #1.5

var shake_enabled = false

var shake_timer

func _ready():
	shake_timer = Timer.new()
	shake_timer.connect('timeout', self, 'shake_timeout')
	add_child(shake_timer)

func shake_timeout() -> void:
	shake_enabled = false
	shake_timer.stop()

func shake(duration: float = 0.2, intensity: float = 2.0) -> void:
	shake_amount = intensity
	shake_enabled = true
	shake_timer.start(duration)

func _process(_delta):
	if shake_enabled:
		set_offset(Vector2( \
			rand_range(-1.0, 1.0) * shake_amount, \
			rand_range(-1.0, 1.0) * shake_amount \
		))
