extends PossessableAI

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

func getAttackLoop() -> String:
	if not attack_started:
		velocity = InputHandler.getAttackDirection(self) * 50
		attack_started = true
		if velocity.x >= 0.1:
			animatedSprite.flip_h = false
		if velocity.x <= -0.1:
			animatedSprite.flip_h = true
		attackNode.look_at(to_global(self.get_local_mouse_position()))
		attackSprite.show()
		attackSprite.play("active")
		if not has_attack_landed:
			has_attack_landed = true
			damageAndKnockBackOverlappingAreas()
	return "attack_loop"

func rotateMeleeAttackNode() -> void:
	var angle_to_target = rad2deg(getAngleToTarget())
	if angle_to_target < -45 and angle_to_target > -135:
		attackNode.look_at(to_global(Vector2.UP))
	elif angle_to_target > 45 and angle_to_target < 135:
		attackNode.look_at(to_global(Vector2.DOWN))
	elif angle_to_target > 135 or angle_to_target < -135:
		attackNode.look_at(to_global(Vector2.LEFT))
	elif angle_to_target < 45 and angle_to_target > -45:
		attackNode.look_at(to_global(Vector2.RIGHT))

func targetOverlapsAttackBox() -> bool:
	var overlappingAreas = attackBox.get_overlapping_areas()
	if overlappingAreas:
		for area in overlappingAreas:
			if (
				GameState.state == GameState.CONTROLLING_PLAYER and
				area.get_name() == "HitBox"
				and area.get_parent().get("IS_PLAYER")
			):
				return true
			elif area.get_name() == "EnemyHitBox" and nodeIsPossessed(area.get_parent()):
				return true
	return false

func damageAndKnockBackOverlappingAreas() -> void:
	var overlappingAreas = attackBox.get_overlapping_areas()
	if overlappingAreas:
		for area in overlappingAreas:
			if area.get_name() == "EnemyHitBox" and area.get_parent() != self:
				var area_parent = area.get_parent()
				area_parent.damage(basic_attack_damage, true)
				area_parent.knockBack(
					get_angle_to(area_parent.get_global_position()),
					200,
					20
				)

func handlePreAttack() -> void:
	rotateMeleeAttackNode()
	.handlePreAttack()

func perAttackAction() -> void:
	if not has_attack_landed:
		attackSprite.show()
		attackSprite.play("active")
		if targetOverlapsAttackBox():
			attack_started = true
			has_attack_landed = true
			target_actor.damage(basic_attack_damage)
			target_actor.knockBack(getAngleToTarget(), 300, 15)

func _on_AttackSprite_animation_finished():
	if nodeIsPossessed(self) and state == ATTACKING:
		has_attack_landed = false
	hideAttackSpriteAndInactive()
