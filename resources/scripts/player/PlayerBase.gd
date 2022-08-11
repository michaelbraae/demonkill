extends CharacterBase

class_name PlayerBase

onready var collisionShape = $CollisionShape2D
onready var camera2D = $Camera2D
onready var possession_hitbox = $PossessionHitBox

const IS_PLAYER = true

var flashTimer: Timer

func _enter_tree() -> void:
	PossessionState.connectToInputSignals(self)

func _ready() -> void:
	UIManager.get_node("PlayerUI").visible = true
	UIManager.get_node("PlayerUI").get_node("MiniMap/TileMap").set_up()
	flashTimer = Timer.new()
	add_child(flashTimer)
	# warning-ignore:return_value_discarded
	flashTimer.connect('timeout', self, 'flash_timeout')
	
	InputHandler.current_actor = self
	GameState.prepareHealthGUI()
	GameState.player = self
	FeedbackHandler.current_camera = camera2D

func flash() -> void:
	pass
#	animatedSprite.material.set_shader_param("flash_modifier", 0.45)
#	flashTimer.start(0.1)

func stun(stun_duration: float) -> void:
	.stun(stun_duration)

func flash_timeout() -> void:
	animatedSprite.material.set_shader_param("flash_modifier", 0)

func damage(damage : int) -> void:
	PlayerState.health -= damage
	flash()
	if PlayerState.health <= 0:
		animatedSprite.material.set_shader_param("flash_modifier", 0)
		LevelManager.goto_scene('res://scenes/main/title_screen/TitleScreen.tscn')
