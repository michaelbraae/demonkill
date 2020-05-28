extends KinematicBody2D

var knockback_handler_script = preload("res://Resources/Scripts/Helpers/Behaviour/KnockBackHandler.gd")
var knockback_handler

# INTRODUCTION
# DEVELOPMENT
# TWIST
# CONCLUSION
var BOLT_SCENE = preload("res://Resources/Abilities/Projectiles/Bolt/Bolt.tscn")

onready var animatedSprite = $AnimatedSprite
onready var interactButton = $InteractButton
onready var interactArea = $InteractArea
onready var collisionShape = $CollisionShape2D
onready var healthBar = $HealthBar
onready var camera2D = $Camera2D
onready var attackSprite = $AttackBox/AnimatedSprite
onready var attackBox = $AttackBox
onready var attackBoxArea2D = $AttackBox/Area2D
onready var fpsCounter = $Camera2D/FPSCounter

const IS_PLAYER = true
const SPEED = 150
const HEALTH_MAX = 10
const HEALTH_MIN = 0
const DASH_COOLDOWN = 0.7
const BOLT_COOLDOWN = 2.0

var dash_cooldown_timer
var bolt_cooldown_timer
var health_current = HEALTH_MAX
var speed_actual
var velocity = Vector2()
var aim_vector = Vector2()

var possessedNPC
var possessing = false

var facing_direction = "down"


func _ready() -> void:
	knockback_handler = knockback_handler_script.new()
	interactButton.hide()
	dash_cooldown_timer = Timer.new()
	add_child(dash_cooldown_timer)
	bolt_cooldown_timer = Timer.new()
	add_child(bolt_cooldown_timer)
	setDeadzones()

func damage(damage : int) -> void:
	health_current = health_current - damage
	if health_current <= HEALTH_MIN:
		get_tree().reload_current_scene()

func knockBack(hit_direction : float) -> void:
	knockback_handler.knockBack(hit_direction)

# sets the aiming deadzones so you can accurately aim
# movement deadzones should be left at default, they cause fuckiness
func setDeadzones():
	InputMap.action_set_deadzone("aim_up", 0.05)
	InputMap.action_set_deadzone("aim_down", 0.05)
	InputMap.action_set_deadzone("aim_left", 0.05)
	InputMap.action_set_deadzone("aim_right", 0.05)



func togglePossession(parent) -> void:
	if possessing:
		set_global_position(possessedNPC.get_global_position())
		animatedSprite.show()
		collisionShape.set_disabled(false)
		possessedNPC = null
		possessing = false
		camera2D.make_current()
	elif parent:
		animatedSprite.hide()
		interactButton.hide()
		collisionShape.set_disabled(true)
		possessedNPC = parent
		possessing = true
		possessedNPC.get_node("Camera2D").make_current()

func handleInteraction() -> void:
	var overlappingInteractAreas = interactArea.get_overlapping_areas()
	if overlappingInteractAreas and not possessing:
		for area in overlappingInteractAreas:
			var parent = area.get_parent()
			if parent.get("INTERACTABLE"):
				interactButton.show()
			else:
				interactButton.hide()
			if Input.is_action_just_pressed("possess") and parent.get("POSSESSABLE"):
				togglePossession(parent)
				break
	else:
		if Input.is_action_just_pressed("possess") and possessing:
			togglePossession(false)
		interactButton.hide()

func getAnimation() -> String:
	if velocity.y <= -45:
		animatedSprite.flip_h = false
		facing_direction = "up"
		return "walk_up"
	if velocity.y >= 45:
		animatedSprite.flip_h = false
		facing_direction = "down"
		return "walk_down"
	if velocity.x >= 45:
		animatedSprite.flip_h = false
		facing_direction = "right"
		return "walk_right"
	if velocity.x <= -45:
		animatedSprite.flip_h = true
		facing_direction = "right"
		return "walk_right"
	return "idle_" + facing_direction

func setVelocity() -> void:
	velocity = Vector2()
	if knockback_handler.getKnockedBack():
		velocity = knockback_handler.getKnockBackProcessVector()
	else:
		velocity.y = Input.get_action_strength("down") - Input.get_action_strength("up")
		velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		if Input.is_action_just_pressed("dash") and dash_cooldown_timer.is_stopped():
			dash_cooldown_timer.start(DASH_COOLDOWN)
			bolt_cooldown_timer.stop()
			collisionShape.disabled = true
			speed_actual = SPEED * 20
		else:
			collisionShape.disabled = false
			speed_actual = SPEED
		velocity = velocity.normalized() * speed_actual

func fireCrossbow():
	if bolt_cooldown_timer.is_stopped():
		bolt_cooldown_timer.start(BOLT_COOLDOWN)
		var bolt_instance = BOLT_SCENE.instance()
		get_parent().add_child(bolt_instance)
		bolt_instance.setTargetId("IS_ENEMY")
		bolt_instance.set_global_position(get_global_position())
		bolt_instance.setTargetDirection(getAttackDirection())

func meleeAttack():
	attackBox.look_at(to_global(getAttackDirection()))
	# should be able to switch between two frames and move forward slightly
	# for different melee attacks:
	#	the player animation can be consistent but the effect can change

func getAttackDirection() -> Vector2:
	# should eventually handle mouse aiming
	aim_vector = Vector2()
	aim_vector.y = Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
	aim_vector.x = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
	aim_vector = aim_vector.normalized()
	if aim_vector:
		return aim_vector
	if velocity:
		return velocity
	var facing_vector = Vector2()
	match facing_direction:
		"up":
			facing_vector.y = -1
		"down":
			facing_vector.y = 1
		"right":
			if animatedSprite.flip_h:
				facing_vector.x = -1
			else:
				facing_vector.x = 1
	return facing_vector.normalized()

func _process(_delta : float) -> void:
	fpsCounter.set_text(str(Engine.get_frames_per_second()))
	if dash_cooldown_timer.get_time_left() <= 0.1:
		dash_cooldown_timer.stop()
	if bolt_cooldown_timer.get_time_left() <= 0.1:
		bolt_cooldown_timer.stop()
	healthBar.play(str(health_current))
	handleInteraction()

func _physics_process(_delta : float) -> void:
	if Input.is_action_just_pressed("attack"):
		meleeAttack()
	if Input.is_action_just_pressed("fire-crossbow"):
		fireCrossbow()
	setVelocity()
	animatedSprite.play(getAnimation())
	if possessing:
		possessedNPC.move_and_slide(velocity)
	else:
		move_and_slide(velocity)
