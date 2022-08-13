extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var area2D = $Area2D

var OUTLINE_SHADER = preload("res://assets/shaders/OutlineShader.tscn")

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

func collisionEffect(_target_actor) -> void:
	FeedbackHandler.current_camera.shake()
# cigarettes after sex

func detectContact() -> void:
		for area in area2D.get_overlapping_areas():
			var area_parent = area.get_parent()
			if area_parent != source_actor and area.get_name() == 'HitBox':
				if area_parent == GameState.player:
					if returning_to_player or distance_timer.is_stopped():
						GameState.player.has_axe = true
						if not returning_to_player:
							PlayerState.addMana(1)
						queue_free()
				elif returning_to_player:
					if not damaged_actors.has(area_parent):
						damaged_actors.append(area_parent)
						area_parent.damage(damage)
						collisionEffect(area_parent)
				elif distance_timer.is_stopped():
					pass
				elif area_parent.health <= damage:
					collisionEffect(area_parent)
				else:
					area_parent.hitByAxe(damage)
					collisionEffect(area_parent)
					GameState.npc_with_axe = area_parent
					GameState.player.axe_recall_available = true
					GameState.axe_instance = null
					queue_free()
					break

func getVectorToPlayer() -> Vector2:
	var angle_to_player = get_angle_to(GameState.player.get_global_position())
	return Vector2(cos(angle_to_player), sin(angle_to_player))

var outline_shader

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
	if not is_instance_valid(outline_shader):
		outline_shader = OUTLINE_SHADER.instance()
		add_child(outline_shader)
	outline_shader.texture = animatedSprite.get_sprite_frames().get_frame(
		animatedSprite.get_animation(),
		animatedSprite.get_frame()
	)
	outline_shader.material.set_shader_param("outline_color", Color(1,1,1,1))
	outline_shader.position = animatedSprite.position
	detectContact()
