extends Camera2D

onready var timer : Timer = $Timer

export var amplitude : = 6.0
export var duration : = 0.8 setget set_duration
export(float, EASE) var DAMP_EASING : = 1.0
export var shake : = false setget set_shake

var enabled : = false

func _ready():
	randomize()
	set_process(false)
	self.duration = duration
	#connect_to_shakers()


func set_duration(value : float) -> void:
	duration = value
	timer.wait_time = duration

func set_shake(value : bool) -> void:
	pass
