extends AttackerAI

class_name MeleeAI

onready var attackNode = $AttackNode
onready var attackBox = $AttackNode/Area2D
onready var attackSprite = $AttackNode/AnimatedSprite

var attack_up_position
var attack_down_position
var attack_left_position
var attack_right_position

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
			attackNode.rotation = 90
			attackSprite.flip_h = false
		"down":
			attackNode.rotation = -90
			attackSprite.flip_h = false
		"left":
			attackSprite.flip_h = true
			attackNode.rotation = 0
		"right":
			attackSprite.flip_h = false
			attackNode.rotation = 0

func getRelativePlayerDirection() -> String:
	var angle_to_player = getAngleToPlayer()
	var direction_string
	if angle_to_player < 0.5 and angle_to_player > -0.5:
		direction_string = "right"
	if angle_to_player < -0.5 and angle_to_player > -2.5:
		direction_string = "up"
	if angle_to_player < -2.5 or angle_to_player > 2.5:
		direction_string = "left"
	if angle_to_player > 0.5 and angle_to_player < 2.5:
		direction_string = "down"
	return direction_string

func perAttackAction() -> void:
	var relative_player_direction = getRelativePlayerDirection()
	rotateAttackNode(relative_player_direction)
	positionAttackNode(relative_player_direction)
	attackSprite.show()
	
