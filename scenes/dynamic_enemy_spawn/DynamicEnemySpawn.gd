extends Node2D

# warning-ignore-all:return_value_discarded

signal enemy_spawned(enemy)

export(PackedScene) var enemy

export var spawn_frame: int = 0

var spawned: bool = false

func _ready() -> void:
	set_process(false)
	$AnimatedSprite.visible = false
	$Icon.visible = false
	$AnimatedSprite.connect("animation_finished", self, "animation_finished")

func begin_spawn() -> void:
	set_process(true)
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("default")

func _process(_delta) -> void:
	if !spawned and $AnimatedSprite.get_frame() == spawn_frame and enemy.can_instance():
		spawn_enemy()

func animation_finished() -> void:
	if !spawned and enemy.can_instance():
		spawn_enemy()
	queue_free()

func spawn_enemy() -> void:
	var enemy_instance = enemy.instance()
	get_tree().get_current_scene().get_node("YSort").add_child(enemy_instance)
	enemy_instance.set_global_position(get_global_position())
	spawned = true
	emit_signal("enemy_spawned", enemy_instance)
	if get_parent() is EncounterStep:
		enemy_instance.connect("character_died", get_parent(), "enemy_died")
