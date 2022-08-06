extends Node

var amplitude := 3.0

var frequency := 5.0

onready var icon = $AnimatedSprite

var time: float = 0.0

onready var default_pos = icon.get_position()

export(PackedScene) var weapon

func _ready() -> void:
	$Area2D.connect("area_entered", self, "on_area_entered")
	pass

func _process(delta: float) -> void:
	time += delta * frequency
	icon.set_position(default_pos + Vector2(0, sin(time) * amplitude))

func on_area_entered(body) -> void:
	if body.get_name() == "InteractionArea" and body.get_parent() == GameState.player:
		body.get_parent().change_weapon_in_slot(weapon, 1)
		queue_free()
