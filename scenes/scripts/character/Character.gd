extends KinematicBody2D

class_name Character

# warning-ignore-all:return_value_discarded

signal character_died(character)

onready var animatedSprite: AnimatedSprite = $AnimatedSprite

var state: int

enum {
	IDLE,
	NAVIGATING,
	DASH,
	DASH_RECOVERY,
	ATTACK_WARMUP,
	ATTACK_CONTACT,
	ATTACK_RECOVERY,
	AXE_INTERACTION,
	KNOCKED_BACK,
	STUNNED,
	PRE_DEATH,
	POSSESSION_TARGETING,
	POSSESSION_DASH,
	POSSESSION_RECOVERY,
}

func get_health() -> int:
	return 0

const ATTACK_STATES = [ATTACK_WARMUP, ATTACK_CONTACT, ATTACK_RECOVERY]

func getStateString() -> String:
	var state_string = 'NO STATE'
	match state:
		IDLE:
			state_string = 'IDLE'
		NAVIGATING:
			state_string = 'NAVIGATING'
		DASH:
			state_string = 'DASH'
		ATTACK_WARMUP:
			state_string = 'ATTACK_WARMUP'
		ATTACK_CONTACT:
			state_string = 'ATTACK_CONTACT'
		ATTACK_RECOVERY:
			state_string = 'ATTACK_RECOVERY'
		AXE_INTERACTION:
			state_string = 'AXE_INTERACTION'
		STUNNED:
			state_string = 'STUNNED'
		PRE_DEATH:
			state_string = 'PRE_DEATH'
		POSSESSION_TARGETING:
			state_string = 'POSSESSION_TARGETING'
		POSSESSION_RECOVERY:
			state_string = 'POSSESSION_RECOVERY'
	return state_string


enum INPUT_QUEUE_OPTIONS {
	SLOT_1_ATTACK,
	SLOT_2_ATTACK,
	MOVEMENT_ABILITY
}

# --- KNOCKBACK LOGIC --- #
var knocked_back = false
var knockback_vector

export var speed: float = 100
var speed_current = speed
var decay

func _ready() -> void:
	animatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")

func input_queued(slot: int) -> void:
	match slot:
		INPUT_QUEUE_OPTIONS.SLOT_1_ATTACK:
			basic_attack()
		INPUT_QUEUE_OPTIONS.SLOT_2_ATTACK:
			attack_slot_2()
		INPUT_QUEUE_OPTIONS.MOVEMENT_ABILITY:
			movement_ability()

# these functions are called by signals emitted by InputEmitter
func basic_attack() -> void:
	pass

func attack_slot_2() -> void:
	pass

func movement_ability() -> void:
	pass

func use_ability() -> void:
	pass

func possession_cast_begun() -> void:
	pass

func possession_cast_ended() -> void:
	pass

func getKnockBackProcessVector() -> Vector2:
	if speed_current < 10:
		speed_current = speed
		knocked_back = false
	speed_current -= decay
	return knockback_vector.normalized() * speed_current

func interruptAction() -> void:
	pass

func stun(stun_duration: float) -> void:
	set_physics_process(false)
	animatedSprite.stop()
	state = STUNNED
	yield(get_tree().create_timer(stun_duration), "timeout")
	set_physics_process(true)
	state = IDLE
	animatedSprite.play()

func knockBack(
	hit_direction : float,
	knock_back_speed : int,
	knock_back_decay : int
) -> void:
	if not knocked_back and ![DASH, STUNNED].has(state):
		interruptAction()
		knocked_back = true
		speed_current = knock_back_speed
		decay = knock_back_decay
		knockback_vector = Vector2(cos(hit_direction), sin(hit_direction))
