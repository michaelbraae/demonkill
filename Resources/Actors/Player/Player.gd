extends PlayerPossession

class_name Player

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

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
