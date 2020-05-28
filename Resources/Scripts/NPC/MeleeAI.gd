extends AttackerAI

class_name MeleeAI

onready var attackNode = $AttackNode
onready var attackBox = $AttackNode/Area2D
onready var attackSprite = $AttackNode/AnimatedSprite

var basic_attack_damage
var attack_up_position
var attack_down_position
var attack_left_position
var attack_right_position

func _ready():
	hideAttackSpriteAndInactive()

func hideAttackSpriteAndInactive() -> void:
	attackSprite.play("inactive")
	attackSprite.hide()

func setBasicAttackDamage(damage_var: int) -> void:
	basic_attack_damage = damage_var

func getBasicAttackDamage() -> int:
	return basic_attack_damage

func setAttackUpPosition(attack_up_var : Vector2) -> void:
	attack_up_position = attack_up_var

func getAttackUpPosition() -> Vector2:
	return attack_up_position

func setAttackDownPosition(attack_down_var : Vector2) -> void:
	attack_down_position = attack_down_var

func getAttackDownPosition() -> Vector2:
	return attack_down_position

func setAttackLeftPosition(attack_left_var) -> void:
	attack_left_position = attack_left_var

func getAttackLeftPosition() -> Vector2:
	return attack_left_position

func setAttackRightPosition(attack_right_var : Vector2) -> void:
	attack_right_position = attack_right_var

func getAttackRightPosition() -> Vector2:
	return attack_right_position

func setAttackNodeRange(attack_range : int) -> void:
	setAttackUpPosition(Vector2(0, -attack_range))
	setAttackDownPosition(Vector2(0, attack_range))
	setAttackLeftPosition(Vector2(-attack_range, 0))
	setAttackRightPosition(Vector2(attack_range, 0))

func positionAttackNode(attack_direction : String) -> void:
	match attack_direction:
		"up":
			attackNode.set_position(getAttackUpPosition())
		"down":
			attackNode.set_position(getAttackDownPosition())
		"left":
			attackNode.set_position(getAttackLeftPosition())
		"right":
			attackNode.set_position(getAttackRightPosition())

func rotateAttackNode(attack_direction : String) -> void:
	match attack_direction:
		"up":
			attackNode.rotation = -80
			attackSprite.flip_h = true
		"down":
			attackNode.rotation = 80
			attackSprite.flip_h = true
		"left":
			attackSprite.flip_h = true
			if not animatedSprite.flip_h:
				animatedSprite.flip_h = true
			attackNode.rotation = 0
		"right":
			attackSprite.flip_h = false
			attackNode.rotation = 0

func getRelativePlayerDirection() -> String:
	var angle_to_player = rad2deg(getAngleToPlayer())
	var direction_string
	print("rad2deg(angle_to_player): ", angle_to_player)
	if angle_to_player < 45 and angle_to_player > -45:
		direction_string = "right"
	elif angle_to_player < -45 and angle_to_player > -135:
		direction_string = "up"
	elif angle_to_player > 135 or angle_to_player < -135:
		direction_string = "left"
	elif angle_to_player > 45 and angle_to_player < 135:
		direction_string = "down"
	return direction_string

func perAttackAction() -> void:
	if not getHasAttackLanded():
		var relative_player_direction = getRelativePlayerDirection()
		rotateAttackNode(relative_player_direction)
		positionAttackNode(relative_player_direction)
		attackSprite.show()
		attackSprite.play("active")
		if isPlayerInRange():
			setAttackStarted(true)
			setHasAttackLanded(true)
			var angle_to_player = get_angle_to(
				getPlayer().get_global_position()
			)
			getPlayer().damage(getBasicAttackDamage())
			getPlayer().knockBack(getAngleToPlayer(), 300, 15)

func _on_AttackSprite_animation_finished():
	hideAttackSpriteAndInactive()
