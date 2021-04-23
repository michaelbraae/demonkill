extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var area2D = $Area2D

onready var FeedbackHandler = get_node('/root/FeedbackHandler')
onready var GameState = get_node('/root/GameState')

var WHITE_IMPACT = preload('res://Resources/Effects/Impacts/WhiteImpact/WhiteImpact.tscn')

var source_actor

var vector = Vector2()

var damaged_actors = []
var speed = 300
var damage = 1

var returning_to_player = false

var distance_timer
const AXE_FLIGHT_TIME_LIMIT = 0.5
var slowdown_speed = speed
var timer_has_started = false

func _ready() -> void:
	distance_timer = Timer.new()
	add_child(distance_timer)
	distance_timer.connect('timeout', self, 'distance_timer_timeout')

func distance_timer_timeout() -> void:
	distance_timer.stop()

func bang(attack_direction : Vector2, source) -> void:
	distance_timer.start(AXE_FLIGHT_TIME_LIMIT)
	source_actor = source
	vector = attack_direction
	position = source.get_position()
	animatedSprite.play()

func returnToPlayer(source) -> void:
	source_actor = source
	returning_to_player = true
	position = source.get_position()
	animatedSprite.play()

func earlyCallback() -> void:
	returning_to_player = true
	source_actor = null

func collisionEffect(target_actor) -> void:
	var impact_instance = WHITE_IMPACT.instance()
	get_tree().get_root().add_child(impact_instance)
	impact_instance.position = target_actor.get_global_position()
	impact_instance.play()
	FeedbackHandler.current_camera.shake()


# cigarettes after sex

func detectContact() -> void:
		for area in area2D.get_overlapping_areas():
			var area_parent = area.get_parent()
			if area_parent != source_actor and area.get_name() == 'HitBox':
				if area_parent == GameState.player:
					if returning_to_player or distance_timer.is_stopped():
						GameState.player.has_axe = true
						queue_free()
				elif returning_to_player:
					if not damaged_actors.has(area_parent):
						damaged_actors.append(area_parent)
						area_parent.damage(1)
						collisionEffect(area_parent)
				elif distance_timer.is_stopped():
					pass
				elif area_parent.health == 1:
					area_parent.kill()
					collisionEffect(area_parent)
				else:
					area_parent.hitByAxe(1)
					collisionEffect(area_parent)
					GameState.npc_with_axe = area_parent
					GameState.player.axe_recall_available = true
					GameState.axe_instance = null
					queue_free()	

func getVectorToPlayer() -> Vector2:
	var angle_to_player = self.get_angle_to(GameState.player.get_global_position())
	return Vector2(cos(angle_to_player), sin(angle_to_player))

func _physics_process(_delta) -> void:
	if returning_to_player:
		animatedSprite.play()
		vector = move_and_slide(getVectorToPlayer().normalized() * speed)
	elif distance_timer.is_stopped():
		if not vector:
			animatedSprite.stop()
		source_actor = null
		vector = move_and_slide(vector.normalized() * slowdown_speed)
		# todo: tween this bitch
		slowdown_speed -= 50
	elif vector:
		vector = move_and_slide(vector.normalized() * speed)
	detectContact()
