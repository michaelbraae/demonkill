extends PlayerAttack

class_name PlayerScript

#extends KinematicBody2D
#
#var knockback_handler_script = preload("res://Resources/Scripts/Helpers/Behaviour/KnockBackHandler.gd")
#var knockback_handler
#
#var input_handler_script = preload("res://Resources/Scripts/Helpers/Input/InputHandler.gd")
#var input_handler
#
## INTRODUCTION
## DEVELOPMENT
## TWIST
## CONCLUSION
#
#var BOLT_SCENE = preload("res://Resources/Abilities/Projectiles/Bolt/Bolt.tscn")
#
#onready var animatedSprite = $AnimatedSprite
##onready var interactButton = $InteractButton
#onready var interactArea = $InteractArea
#onready var collisionShape = $CollisionShape2D
#onready var healthBar = $HealthBar
#onready var camera2D = $Camera2D
#onready var attackSprite = $AttackBox/AttackSprite
#onready var attackBox = $AttackBox
#onready var attackBoxArea2D = $AttackBox/Area2D
#onready var fpsCounter = $Camera2D/FPSCounter
#
#const IS_PLAYER = true
#const SPEED = 150
#const HEALTH_MAX = 10
#const HEALTH_MIN = 0
#const DASH_COOLDOWN = 0.7
#const BOLT_COOLDOWN = 2.0
#
#var dash_cooldown_timer
#var bolt_cooldown_timer
#var health_current = HEALTH_MAX
#var speed_actual
#var velocity = Vector2()
#var aim_vector = Vector2()
#
#var possessedNPC
#var possessing = false
#
#var facing_direction = "down"
#
#var attacking = false
#
#func _ready() -> void:
#	attackSprite.hide()
#	knockback_handler = knockback_handler_script.new()
#	input_handler = input_handler_script.new()
#	input_handler.setDeadzones()
#	input_handler.mouseLogic()
#	input_handler.setDeadzones()
##	interactButton.hide()
#	dash_cooldown_timer = Timer.new()
#	add_child(dash_cooldown_timer)
#	bolt_cooldown_timer = Timer.new()
#	add_child(bolt_cooldown_timer)
#
#func damage(damage : int) -> void:
#	health_current = health_current - damage
#	if health_current <= HEALTH_MIN:
#		get_tree().reload_current_scene()
#
#func knockBack(
#	hit_direction : float,
#	knock_back_speed : int,
#	knock_back_decay : int
#) -> void:
#	knockback_handler.knockBack(
#		hit_direction,
#		knock_back_speed,
#		knock_back_decay
#	)
#
##func togglePossession(parent) -> void:
##	if possessing:
##		set_global_position(possessedNPC.get_global_position())
##		animatedSprite.show()
##		collisionShape.set_disabled(false)
##		possessedNPC = null
##		possessing = false
##		camera2D.make_current()
##	elif parent:
##		animatedSprite.hide()
##		interactButton.hide()
##		collisionShape.set_disabled(true)
##		possessedNPC = parent
##		possessing = true
##		possessedNPC.get_node("Camera2D").make_current()
##
##func handleInteraction() -> void:
##	var overlappingInteractAreas = interactArea.get_overlapping_areas()
##	if overlappingInteractAreas and not possessing:
##		for area in overlappingInteractAreas:
##			var parent = area.get_parent()
##			if parent.get("INTERACTABLE"):
##				interactButton.show()
##			else:
##				interactButton.hide()
##			if Input.is_action_just_pressed("possess") and parent.get("POSSESSABLE"):
##				togglePossession(parent)
##				break
##	else:
##		if Input.is_action_just_pressed("possess") and possessing:
##			togglePossession(false)
##		interactButton.hide()
#
#func getAnimation() -> String:
#	if velocity.y <= -45:
#		animatedSprite.flip_h = false
#		facing_direction = "up"
#		return "walk_up"
#	if velocity.y >= 45:
#		animatedSprite.flip_h = false
#		facing_direction = "down"
#		return "walk_down"
#	if velocity.x >= 45:
#		animatedSprite.flip_h = false
#		facing_direction = "right"
#		return "walk_right"
#	if velocity.x <= -45:
#		animatedSprite.flip_h = true
#		facing_direction = "right"
#		return "walk_right"
#	return "idle_" + facing_direction
#
#func fireCrossbow():
#	if bolt_cooldown_timer.is_stopped():
#		bolt_cooldown_timer.start(BOLT_COOLDOWN)
#		var bolt_instance = BOLT_SCENE.instance()
#		get_parent().add_child(bolt_instance)
#		bolt_instance.setTargetId("IS_ENEMY")
#		bolt_instance.set_global_position(get_global_position())
#		bolt_instance.setTargetDirection(getAttackDirection())
#
#func meleeAttack():
#	attacking = true
#	attackBox.look_at(to_global(getAttackDirection()))
#	attackSprite.play("melee_basic")
#	attackSprite.show()
#	print("meleeAttack()")
#	# move toward attackDirection for the duration of the attack
#	var overlappingAreas = attackBoxArea2D.get_overlapping_areas()
#	if overlappingAreas:
#		for area in overlappingAreas:
#			var area_parent = area.get_parent()
#			if area.get_name() == "HitBox" and area_parent.get("IS_ENEMY"):
#				print("should knockback")
#				area_parent.damage(0)
#				area_parent.knockBack(
#					get_angle_to(area_parent.get_global_position()),
#					200,
#					20
#				)
#	# should be able to switch between two frames and move forward slightly
#	# for different melee attacks:
#	#	the player animation can be consistent but the effect can change
#
#func getAttackDirection() -> Vector2:
#	if input_handler.using_mouse:
#		return Vector2(get_local_mouse_position().normalized())
#	aim_vector = Vector2()
#	aim_vector.y = Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
#	aim_vector.x = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
#	aim_vector = aim_vector.normalized()
#	if aim_vector:
#		return aim_vector
#	if velocity:
#		return velocity
#	var facing_vector = Vector2()
#	match facing_direction:
#		"up":
#			facing_vector = Vector2.UP
#		"down":
#			facing_vector = Vector2.DOWN
#		"right":
#			if animatedSprite.flip_h:
#				facing_vector = Vector2.LEFT
#			else:
#				facing_vector = Vector2.RIGHT
#	return facing_vector.normalized()
#
#func setVelocity() -> void:
#	velocity = Vector2()
#	if knockback_handler.getKnockedBack():
#		velocity = knockback_handler.getKnockBackProcessVector()
#	else:
#		velocity.y = Input.get_action_strength("down") - Input.get_action_strength("up")
#		velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
#		if Input.is_action_just_pressed("dash") and dash_cooldown_timer.is_stopped():
#			dash_cooldown_timer.start(DASH_COOLDOWN)
#			bolt_cooldown_timer.stop()
#			collisionShape.set_disabled(true)
#			speed_actual = SPEED * 20
#		else:
#			collisionShape.set_disabled(false)
#			speed_actual = SPEED
#		velocity = velocity.normalized() * speed_actual
#
#func _process(_delta : float) -> void:
#	fpsCounter.set_text(str(Engine.get_frames_per_second()))
#	if dash_cooldown_timer.get_time_left() <= 0.1:
#		dash_cooldown_timer.stop()
#	if bolt_cooldown_timer.get_time_left() <= 0.1:
#		bolt_cooldown_timer.stop()
#	healthBar.play(str(health_current))
##	handleInteraction()
#
#func _physics_process(_delta : float) -> void:
#	if Input.is_action_just_pressed("attack"):
#		meleeAttack()
#	if Input.is_action_just_pressed("fire-crossbow"):
#		fireCrossbow()
#	if attacking:
#		velocity = getAttackDirection() * 50
#	else:
#		setVelocity()
#	animatedSprite.play(getAnimation())
#	if possessing:
#		possessedNPC.move_and_slide(velocity)
#	else:
#		move_and_slide(velocity)
#
#func _on_AttackSprite_animation_finished():
#	attacking = false
#	attackSprite.stop()
#	attackSprite.hide()
