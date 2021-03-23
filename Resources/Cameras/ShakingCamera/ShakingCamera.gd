extends Camera2D

var shake_amount = 1.5

var shake_enabled = false

var shake_timer

func _ready():
	shake_timer = Timer.new()
	add_child(shake_timer)

func shake() -> void:
	shake_enabled = true
	shake_timer.start(0.2)

func _process(_delta):
	if shake_enabled:
		set_offset(Vector2( \
			rand_range(-1.0, 1.0) * shake_amount, \
			rand_range(-1.0, 1.0) * shake_amount \
		))

func _physics_process(_delta):
	if shake_timer.get_time_left() < 0.1:
		shake_enabled = false
		shake_timer.stop()
