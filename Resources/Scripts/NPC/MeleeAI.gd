extends AttackerAI

# declare some variables for the attack positions
# up, down, left, right

# they cant really be constants
# because different npcs will have different ranges..

# so i guess i have no choice but to have getters and setters .. sigh

var attack_up
var attack_down
var attack_left
var attack_right

func setAttackUp(attack_up_var : Vector2) -> void:
	attack_up = attack_up_var

func getAttackUp() -> Vector2:
	return attack_up

func setAttackDown(attack_down_var : Vector2) -> void:
	attack_down = attack_down_var

func getAttackDown() -> Vector2:
	return attack_down

func setAttackLeft(attack_left_var) -> void:
	attack_left = attack_left_var

func getAttackLeft() -> Vector2:
	return attack_left

func setAttackRight(attack_right_var : Vector2) -> void:
	attack_right = attack_right_var

func getAttackRight() -> Vector2:
	return attack_right
