extends Node2D

# warning-ignore-all:return_value_discarded

var amplitude := 3.0

var frequency := 5.0

var time: float = 0.0

onready var icon: AnimatedSprite = $AnimatedSprite

onready var default_pos = icon.get_position()

func _ready() -> void:
	$Area2D.connect("area_entered", self, "pickup_area_entered")

func pickup_area_entered(body) -> void:
	if body.owner == GameState.player and !GameState.player.possession_dash_cooldown_timer.is_stopped():
		GameState.player.possession_dash_cooldown_timer.stop()
		FeedbackHandler.shake_camera()
		queue_free()

func _process(delta: float) -> void:
	time += delta * frequency
	icon.set_position(default_pos + Vector2(0, sin(time) * amplitude))
