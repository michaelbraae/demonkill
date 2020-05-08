extends Node
var timer

#const DAY_LENGTH = 480
const DAY_LENGTH = 48
var time_of_day

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.start(DAY_LENGTH)

func _process(_delta):
	var time_left = timer.get_time_left()
#	if time_left > 200:
	if time_left > 20:
		time_of_day = "day"
#	elif time_left < 200 and time_left > 150:
	elif time_left < 20 and time_left > 15:
		time_of_day = "dusk"
#	elif time_left < 150:
	elif time_left < 15:
		time_of_day = "night"
	if timer.is_stopped():
		timer.start(DAY_LENGTH)
