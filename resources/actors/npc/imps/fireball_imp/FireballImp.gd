extends PossessableAI

var SWIPE_SCENE = preload('res://resources/abilities/swipe/Swipe.tscn')
var FIREBALL_SCENE = preload('res://resources/abilities/pickup_ability/fireball/Fireball.tscn')
var PICKUP_FIREBALL_SCENE = preload('res://resources/abilities/pickup_ability/fireball/pickup/PickupFireball.tscn')

onready var health_label = $HealthLabel

func initialiseConfig():
	max_health = 3
	move_speed = 30 # 70
	attacks_in_sequence = 1
	repeat_attacks = true
	attack_range = 30
	attack_cooldown = 1
	ability_range = 300
	ability_cooldown = 1
	too_close_range = 70
	complete_attack_sequence = true

func setHealth() -> void:
	$HealthBar.max_value = max_health
	$HealthBar.value = health

func beforeDeath() -> void:
	.beforeDeath()
	var pickup_ability = PICKUP_FIREBALL_SCENE.instance()
	pickup_ability.position = position
	get_tree().get_root().add_child(pickup_ability)

func useAbility() -> void:
	var fireball = FIREBALL_SCENE.instance()
	if not isPossessed():
		fireball.setCollideWithPlayer()
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

func _process(_delta):
		# need to make the AI dodge back when it enters the light and reduce dodge cooldown
		# adding like 30 imp-melees could be really cool, like plague tale rat vibes
	setHealth()
