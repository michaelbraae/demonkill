extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var attackRange = $AttackRange
onready var attackBox = $AttackBox
onready var playerDetectionArea = $PlayerDetectionArea

const ATTACK_UP = Vector2(0, -40)
const ATTACK_DOWN = Vector2(0, 40)
const ATTACK_LEFT = Vector2(-40, 0)
const ATTACK_RIGHT = Vector2(40, 0)
const BASIC_ATTACK_DAMAGE = 3
const PLAYER_TRACK_OFFSET = 25
const IS_ENEMY = true

# stealth mechanics
var player

var attack_started = false
var attacked = false

var velocity = Vector2()
var speed = 120

var health = 10

func detectPlayer() -> void:
	var playerDetectionOverlaps = playerDetectionArea.get_overlapping_areas()
	if playerDetectionOverlaps:
		for area in playerDetectionOverlaps:
			if area.get_parent().get("IS_PLAYER"):
				player = area.get_parent()

func hit(damage) -> void:
	health = health - damage
	if health <= 0:
		queue_free()

func getPlayerRelativeLocation() -> String:
	var player_position = player.get_global_position()
	var knight_position = get_global_position()
	if player_position.x > knight_position.x:
		return "right"
	if player_position.x + PLAYER_TRACK_OFFSET < knight_position.x:
		return "left"
	if player_position.y + PLAYER_TRACK_OFFSET > knight_position.y:
		return "down"
	if player_position.y - PLAYER_TRACK_OFFSET < knight_position.y:
		return "up"
	return "down"

func attackIfInRange() -> void:
	var attack_range_areas = attackRange.get_overlapping_areas()
	if attack_started and attack_range_areas and not attacked:
		for area in attack_range_areas:
			if area.get_parent().get("IS_PLAYER") and not attacked:
				if [3, 4, 5].has(animatedSprite.get_frame()):
					attacked = true
					area.get_parent().hit(BASIC_ATTACK_DAMAGE)
	if not attack_started and attack_range_areas:
			for area in attack_range_areas:
				if area.get_parent().get("IS_PLAYER"):
					attack_started = true
					animatedSprite.play("attack")
					aimAttack()

func aimAttack() -> void:
	match getPlayerRelativeLocation():
		"right":
			attackBox.set_position(ATTACK_RIGHT)
		"left":
			attackBox.set_position(ATTACK_LEFT)
		"up":
			attackBox.set_position(ATTACK_UP)
		"down":
			attackBox.set_position(ATTACK_DOWN)

func getAnimation() -> String:
	if velocity.x > 0 + PLAYER_TRACK_OFFSET:
		animatedSprite.flip_h = true
		return "run"
	if velocity.x <= 0 - PLAYER_TRACK_OFFSET:
		animatedSprite.flip_h = false
		return "run"
	return "idle"

func moveToPlayerLocation():
	velocity = Vector2()
	animatedSprite.play("run")
	var player_position = player.get_global_position()
	var knight_position = get_global_position()
	if player_position.x > knight_position.x:
		velocity.x += 1
	if player_position.x + PLAYER_TRACK_OFFSET < knight_position.x:
		velocity.x -= 1
	if player_position.y + PLAYER_TRACK_OFFSET > knight_position.y:
		velocity.y += 1
	if player_position.y - PLAYER_TRACK_OFFSET < knight_position.y:
		velocity.y -= 1
#	animatedSprite.play(getAnimation())
	velocity = velocity.normalized() * speed
	move_and_slide(velocity)

func attackPlayer() -> void:
	attackIfInRange()
	if not attack_started:
		moveToPlayerLocation()

func _physics_process(_delta : float) -> void:
	detectPlayer()
	if player:
		attackPlayer()
	else:
		pass
		# do some wandering

func _on_AnimatedSprite_animation_finished() -> void:
	attack_started = false
	attacked = false
