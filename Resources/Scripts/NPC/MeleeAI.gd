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

func rotateMeleeAttackNode() -> void:
	var angle_to_player = rad2deg(getAngleToPlayer())
	if angle_to_player < -45 and angle_to_player > -135:
		attackNode.look_at(to_global(Vector2.UP))
	elif angle_to_player > 45 and angle_to_player < 135:
		attackNode.look_at(to_global(Vector2.DOWN))
	elif angle_to_player > 135 or angle_to_player < -135:
		attackNode.look_at(to_global(Vector2.LEFT))
	elif angle_to_player < 45 and angle_to_player > -45:
		attackNode.look_at(to_global(Vector2.RIGHT))

func detectPlayerHit() -> bool:
	var overlappingAreas = attackBox.get_overlapping_areas()
	if overlappingAreas:
		for area in overlappingAreas:
			if (
				area.get_name() == "HitBox"
				and area.get_parent().get("IS_PLAYER")
			):
				return true
	return false

func handlePreAttack() -> void:	
	rotateMeleeAttackNode()
	.handlePreAttack()

func perAttackAction() -> void:
	if not getHasAttackLanded():
		attackSprite.show()
		attackSprite.play("active")
		if detectPlayerHit():
			setAttackStarted(true)
			setHasAttackLanded(true)
			getPlayer().damage(getBasicAttackDamage())
			getPlayer().knockBack(getAngleToPlayer(), 300, 15)

func _on_AttackSprite_animation_finished():
	hideAttackSpriteAndInactive()
