extends Node2D

class_name EncounterStep

signal step_finished(step)

var active_enemies: Array = []

func _ready() -> void:
	for enemy_spawn in get_children():
		enemy_spawn.connect("enemy_spawned", self, "enemy_spawned")
	set_process(false)

func begin_step() -> void:
	for enemy_spawn in get_children():
		enemy_spawn.begin_spawn()

func enemy_spawned(enemy) -> void:
	if is_instance_valid(enemy):
		active_enemies.push_front(enemy)

func enemy_died(character: Character) -> void:
	var enemy = active_enemies.find(character)
	active_enemies.remove(enemy)
	if !active_enemies.size():
		emit_signal("step_finished", self)
