extends PlayerAnimation

class_name PlayerAttack

var attacking = false

var melee_node_moved = false

func _on_AttackSprite_animation_finished():
	attacking = false
	attackSprite.stop()
	attackSprite.hide()

func positionAttackNode() -> void:
	attacking = true
	attackBox.look_at(to_global(getAttackDirection()))
	attackSprite.play("melee_basic")
	attackSprite.show()

func damageAndKnockBackOverlappingAreas() -> void:
	var overlappingAreas = attackBoxArea2D.get_overlapping_areas()
	if overlappingAreas:
		for area in overlappingAreas:
			if area.get_name() == "EnemyHitBox":
				var area_parent = area.get_parent()
				area_parent.damage(3)
				area_parent.knockBack(
					get_angle_to(area_parent.get_global_position()),
					200,
					20
				)

func _physics_process(_delta : float) -> void:
	if Input.is_action_just_pressed("fire_weapon"):
		current_weapon.fire(getAttackDirection())
	if Input.is_action_just_pressed("attack") or melee_node_moved:
		if not melee_node_moved:
			melee_node_moved = true
			positionAttackNode()
		else:
			damageAndKnockBackOverlappingAreas()
			melee_node_moved = false
	if attacking:
		velocity = getAttackDirection() * 50
	else:
		setVelocity()
	animatedSprite.play(getAnimation())
	if possessing:
		pass
#		possessedNPC.move_and_slide(velocity)
	else:
		move_and_slide(velocity)
