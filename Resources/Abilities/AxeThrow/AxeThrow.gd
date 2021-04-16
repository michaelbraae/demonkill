extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var area2D = $Area2D

onready var FeedbackHandler = get_node('/root/FeedbackHandler')

var source_actor

var vector = Vector2()

var damaged_actors = []
var attack_move_speed = 250
var damage = 1

# when returning, the axe should speed up

func bang(attack_direction : Vector2, source) -> void:
	source_actor = source
	vector = attack_direction
	position = source.get_position()
	look_at(to_global(vector))
	animatedSprite.play()

func _physics_process(_delta) -> void:
	if vector:
		vector = move_and_slide(vector.normalized() * attack_move_speed)
