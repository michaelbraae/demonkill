extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var area2D = $Area2D

onready var FeedbackHandler = get_node('/root/FeedbackHandler')
onready var GameState = get_node('/root/GameState')

var source_actor

var vector = Vector2()

var damaged_actors = []
var attack_move_speed = 250
var damage = 1

var returning_to_player = false

# When returning, the axe should speed up

func bang(attack_direction : Vector2, source) -> void:
	source_actor = source
	vector = attack_direction
	position = source.get_position()
	animatedSprite.play()

func returnToPlayer(source) -> void:
	source_actor = source
	returning_to_player = true
	position = source.get_position()
	animatedSprite.play()

func detectContact() -> void:
		for area in area2D.get_overlapping_areas():
			if area.get_parent() != source_actor and area.get_name() == 'HitBox':
				if returning_to_player:
					if area.get_parent() == GameState.player:
						GameState.player.has_axe = true
						queue_free()
				else:
					area.get_parent().hitByAxe()
					GameState.npc_with_axe = area.get_parent()
					GameState.player.axe_recall_available = true
					queue_free()	

func getVectorToPlayer() -> Vector2:
	var angle_to_player = self.get_angle_to(GameState.player.get_global_position())
	return Vector2(cos(angle_to_player), sin(angle_to_player))

func _physics_process(_delta) -> void:
	if returning_to_player:
		vector = move_and_slide(getVectorToPlayer().normalized() * attack_move_speed)
	elif vector:
		vector = move_and_slide(vector.normalized() * attack_move_speed)
	detectContact()
