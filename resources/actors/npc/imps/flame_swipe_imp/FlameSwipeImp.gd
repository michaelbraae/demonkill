extends PossessableAI

var SWIPE_SCENE = preload('res://resources/abilities/swipe/Swipe.tscn')
var ABILITY_SCENE = preload('res://resources/abilities/pickup_ability/flame_swipe/FlameSwipe.tscn')
var PICKUP_ABILITY_SCENE = preload('res://resources/abilities/pickup_ability/flame_swipe/pickup/PickupFlameSwipe.tscn')

func initialiseConfig() -> void:
	max_health = 3
	move_speed = 70
	attack_range = 30
	attack_cooldown = 1
#	ability_range = 50
#	ability_cooldown = 5

func useAbility() -> void:
	var ability_instance = ABILITY_SCENE.instance()
	add_child(ability_instance)
	if not isPossessed():
		ability_instance.target_actor = target_actor
	var angle = getAttackAngle()
	ability_instance.bang(Vector2(cos(angle), sin(angle)), self)

func perAttackAction() -> void:
	var swipe_instance = SWIPE_SCENE.instance()
	add_child(swipe_instance)
	var angle = getAttackAngle()
	swipe_instance.bang(Vector2(cos(angle), sin(angle)), self)

func _process(_delta):
	setHealth()
