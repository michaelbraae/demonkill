extends Node2D

# warning-ignore-all:return_value_discarded

export(PackedScene) var enemy

export var spawn_frame: int = 0

var spawned: bool = false

func _ready():
	$Icon.visible = false
	$AnimatedSprite.connect("animation_finished", self, "animation_finished")
	$AnimatedSprite.play()

func _process(_delta) -> void:
	if !spawned and $AnimatedSprite.get_frame() == spawn_frame and enemy.can_instance():
		var enemy_instance = enemy.instance()
		get_tree().get_current_scene().get_node("YSort").add_child(enemy_instance)
		enemy_instance.position = position
		spawned = true

func animation_finished() -> void:
	if !spawned and enemy.can_instance():
		var enemy_instance = enemy.instance()
		get_tree().get_current_scene().get_node("YSort").add_child(enemy_instance)
		enemy_instance.position = position
		spawned = true
	queue_free()
