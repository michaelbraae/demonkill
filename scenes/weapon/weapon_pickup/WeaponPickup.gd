extends Node2D

var amplitude := 3.0

var frequency := 5.0

onready var icon = $Sprite

var time: float = 0.0

onready var default_pos = icon.get_position()

export(PackedScene) var weapon

# warning-ignore-all:return_value_discarded

func _ready() -> void:
	InputEmitter.connect("interacted", self, "interacted")
	var weapon_instance = weapon.instance()
	$WeaponCard.weapon = weapon_instance
	$WeaponCard.set_params()
	$Sprite.set_texture(weapon_instance.weapon_icon)
	weapon_instance.queue_free()

func interacted() -> void:
	if $WeaponCard.visible:
		GameState.player.change_weapon_in_slot(weapon, 1)
		queue_free()

func _process(delta: float) -> void:
	time += delta * frequency
	icon.set_position(default_pos + Vector2(0, sin(time) * amplitude))
	if get_global_position().distance_to(GameState.player.position) < 30:
		$WeaponCard.visible = true
	else:
		$WeaponCard.visible = false
