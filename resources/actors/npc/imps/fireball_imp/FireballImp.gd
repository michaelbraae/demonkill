extends PossessableAI

var SWIPE_SCENE = preload('res://resources/abilities/swipe/Swipe.tscn')
var FIREBALL_SCENE = preload('res://resources/abilities/pickup_ability/fireball/Fireball.tscn')
var PICKUP_FIREBALL_SCENE = preload('res://resources/abilities/pickup_ability/fireball/pickup/PickupFireball.tscn')

func initialiseConfig() -> void:
	max_health = 2
	move_speed = 30
	attack_range = 30
	too_close_range = 70

func useAbility() -> void:
	var fireball = FIREBALL_SCENE.instance()
	if not isPossessed():
		fireball.setCollideWithPlayer()
	else:
		fireball.setCollideWithEnemies()
	fireball.position = position
	var angle = getAttackAngle()
	fireball.target_vector = Vector2(cos(angle), sin(angle))
	get_tree().get_root().add_child(fireball)

func perAttackAction() -> void:
	var swipe_instance = SWIPE_SCENE.instance()
	add_child(swipe_instance)
#	swipe_instance.target_actor = target_actor
	var angle = getAttackAngle()
	swipe_instance.bang(Vector2(cos(angle), sin(angle)), self)

func _process(_delta) -> void:
		# need to make the AI dodge back when it enters the light and reduce dodge cooldown
		# adding like 30 imp-melees could be really cool, like plague tale rat vibes
	setHealth()
