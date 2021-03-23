extends PlayerAnimation

class_name PlayerAttack

var attacking = false

var melee_attack

enum MELEE_ATTACKS {
	BASIC,
}

var melee_node_moved = false

func _ready():
	melee_attack = MELEE_ATTACKS.BASIC

func _on_AttackSprite_animation_finished():
	attacking = false
	attackSprite.stop()
	attackSprite.hide()

func positionAttackNode() -> void:
	attacking = true
	attackBox.look_at(to_global(getAttackDirection()))
	attackSprite.play('melee_basic')
	attackSprite.show()

func damageAndKnockBackOverlappingAreas() -> void:
	camera2D.shake()
	var overlappingAreas = $AttackBox/Area2D.get_overlapping_areas()
	if overlappingAreas:
		for area in overlappingAreas:
			if area.get_name() == 'EnemyHitBox':
				var area_parent = area.get_parent()
				area_parent.damage(1, true)
				area_parent.knockBack(
					get_angle_to(area_parent.get_global_position()),
					200,
					20
				)

func meleeAttack():
	current_weapon.state = current_weapon.UNEQUIPPED
	match melee_attack:
		MELEE_ATTACKS.BASIC:
			if not melee_node_moved:
				melee_node_moved = true
				positionAttackNode()
			else:
				damageAndKnockBackOverlappingAreas()
				melee_node_moved = false

func _physics_process(_delta : float) -> void:
	handlePlayerAction()

func handlePlayerAction() -> void:
	if Input.is_action_just_pressed('fire_weapon'):
		fireCurrentWeapon()
	if Input.is_action_just_pressed('melee_attack') or melee_node_moved:
		meleeAttack()
	if attacking:
		velocity = getAttackDirection() * 50
	else:
		setVelocity()
	animatedSprite.play(getAnimation())
	move_and_slide(velocity)
