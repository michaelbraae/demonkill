extends PossessableAI

var SWIPE_SCENE = preload('res://Resources/Abilities/Swipe/Swipe.tscn')

onready var health_label = $HealthLabel

func initialiseConfig():
	max_health = 3
	move_speed = 70
	attacks_in_sequence = 1
	repeat_attacks = true
	attack_range = 30 #30
	ability_range = 50
	attack_cooldown = 1
	complete_attack_sequence = true

func setHealth() -> void:
	health_label.set_text(str(health, '/', max_health))

func useAbility() -> void:
	print('useAbility()')
	# instance the fireball
	var swipe_instance = SWIPE_SCENE.instance()
	add_child(swipe_instance)
	swipe_instance.target_actor = target_actor
	var angle = get_angle_to(target_actor.get_global_position())
	swipe_instance.bang(Vector2(cos(angle), sin(angle)), self)

func perAttackAction() -> void:
	var swipe_instance = SWIPE_SCENE.instance()
	add_child(swipe_instance)
	swipe_instance.target_actor = target_actor
	var angle = get_angle_to(target_actor.get_global_position())
	swipe_instance.bang(Vector2(cos(angle), sin(angle)), self)

func _process(_delta):
		# need to make the AI dodge back when it enters the light and reduce dodge cooldown
		# adding like 30 Imp-melees could be really cool, like plague tale rat vibes
	setHealth()
