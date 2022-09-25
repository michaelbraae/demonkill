extends Node2D

# warning-ignore-all:return_value_discarded

export(Array, PackedScene) var encounter_steps

export(PackedScene) var encounter_reward
export(PackedScene) var encounter_reward_vfx

onready var reward_position: Position2D = $RewardPosition

var active_encounter_steps = []

var step_index: int = 0

func _ready() -> void:
	$Area2D.connect("area_entered", self, "area_entered")

func area_entered(body) -> void:
	print("area_entered: ", body.get_name())
	if body == PossessionState.get_player_controlled_character():
		print("player entered")
		begin_encounter()

func begin_encounter() -> void:
	$DoorTileMap.visible = true
	begin_encounter_step(0)

func begin_encounter_step(step: int) -> void:
	if encounter_steps[step].can_instance():
		var step_instance = encounter_steps[step].instance()
		add_child(step_instance)
		step_instance.connect("step_finished", self, "encounter_step_end")
		step_index += 1

func encounter_step_end() -> void:
	if active_encounter_steps.empty():
		if step_index <= encounter_steps.size():
			begin_next_encounter_step()
		else:
			encounter_reward_step()

func begin_next_encounter_step():
	begin_encounter_step(step_index)

func encounter_reward_step() -> void:
	if encounter_reward and encounter_reward.can_instance():
		var reward_instance = encounter_reward.instance()
		add_child(reward_instance)
		reward_instance.position = reward_position
	if encounter_reward_vfx and encounter_reward_vfx.can_instance():
		var reward_vfx_instance = encounter_reward_vfx.instance()
		add_child(reward_vfx_instance)
		reward_vfx_instance.position = reward_position
	$DoorTileMap.visible = false
