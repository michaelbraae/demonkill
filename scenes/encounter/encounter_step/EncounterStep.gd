extends Node2D

class_name EncounterStep

var active_enemies: Array = []

func _ready() -> void:
	for enemy_spawn in get_children():
		enemy_spawn.connect("enemy_spawned", self, "enemy_spawned")

func begin_step() -> void:
	for enemy_spawn in get_children():
		enemy_spawn.begin_spawn()

func enemy_spawned(enemy) -> void:
	if is_instance_valid(enemy):
		active_enemies.push_front(enemy)


# func encounter_step_enemy_died(character: Character) -> void:
# 	print(character)
# 	print("active_enemies.size()", active_enemies.size())
