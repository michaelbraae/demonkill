extends CharacterBase

class_name PlayerBase

onready var animatedSprite = $AnimatedSprite
onready var collisionShape = $CollisionShape2D
onready var camera2D = $Camera2D
onready var possession_hitbox = $PossessionHitBox

const IS_PLAYER = true

var flashTimer: Timer

enum {
	NAVIGATING,
	ATTACK_WARMUP,
	ATTACK_CONTACT,
	ATTACK_RECOVERY,
	ATTACKING,
	AXE_THROW,
	AXE_RECALL,
	DASH,
	DASH_RECOVERY,
	POSSESSION_TARGETING,
	POSSESSION_DASH,
}

const ATTACK_STATES = [ATTACK_WARMUP, ATTACK_CONTACT, ATTACK_RECOVERY]

func getStateString() -> String:
	var state_string = 'NO_STATE'
	match state:
		NAVIGATING:
			state_string = 'NAVIGATING'
		IDLE:
			state_string = 'IDLE'
		ATTACKING:
			state_string = 'ATTACKING'
		DASH:
			state_string = 'DASH'
		DASH_RECOVERY:
			state_string = 'DASH_RECOVERY'
		POSSESSION_TARGETING:
			state_string = "POSSESSION_TARGETING"
		POSSESSION_DASH:
			state_string = "POSSESSION_DASH"
	return state_string

func _ready() -> void:
	# white flash when taking damage
	flashTimer = Timer.new()
	add_child(flashTimer)
	flashTimer.connect('timeout', self, 'flash_timeout')
	
	InputHandler.current_actor = self
	GameState.prepareHealthGUI()
	FeedbackHandler.current_camera = camera2D
	PossessionState.bite_box = possession_hitbox

func flash() -> void:
	animatedSprite.material.set_shader_param("flash_modifier", 0.45)
	flashTimer.start(0.1)

func flash_timeout() -> void:
	animatedSprite.material.set_shader_param("flash_modifier", 0)

func damage(damage : int) -> void:
	PlayerState.health -= damage
	flash()
	if PlayerState.health <= 0:
		animatedSprite.material.set_shader_param("flash_modifier", 0)
		LevelManager.goto_scene('res://scenes/levels/Town.tscn')
