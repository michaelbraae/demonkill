extends Node2D

# warning-ignore-all:return_value_discarded

export(PackedScene) var encounter_reward
export(PackedScene) var encounter_reward_vfx

onready var reward_position: Position2D = $RewardPosition

var active_encounter_steps = []

var step_index: int = 0

var encounter_started: bool = false

func _ready() -> void:
	for child in $Steps.get_children():
		child.visible = true
	$Area2D.connect("area_entered", self, "area_entered")

func area_entered(body) -> void:
	if !encounter_started and body.get_parent() == PossessionState.get_player_controlled_character():
		print("player entered")
		encounter_started = true
		begin_encounter()

func begin_encounter() -> void:
	$DoorTileMap.visible = true
	begin_encounter_step(0)

func begin_encounter_step(step: int) -> void:
	var steps = $Steps.get_children()
	if range(steps.size()).has(step):
		var active_step = steps[step]
		active_step.set_process(true)
		active_encounter_steps.push_front(active_step)
		active_step.begin_step()
		active_step.connect("step_finished", self, "encounter_step_end")
		step_index += 1

func encounter_step_end(step: EncounterStep) -> void:
	var step_in_array = active_encounter_steps.find(step)
	active_encounter_steps.remove(step_in_array)
	if active_encounter_steps.empty():
		if step_index <= $Steps.get_children().size():
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
