extends Node

const PLAYER_SCENE = preload('res://resources/actors/player/Player.tscn')

var bite_box

var current_possession

var possessedNPC

var possession_timer

var possession_time_threshold = 0.3

var bite_started = false

func _ready():
	possession_timer = Timer.new()
	possession_timer.connect('timeout', self, 'possession_timer_timeout')
	add_child(possession_timer)

func possession_timer_timeout():
	if bite_started:
		Engine.time_scale = 1
		InputHandler.mute_inputs = false
		possessNewEntity()

func getCurrentPossession():
	if GameState.CONTROLLING_NPC and current_possession:
		return current_possession
	return GameState.player

func initiateBite(current_possession_var):
	InputHandler.mute_inputs = true
	current_possession = current_possession_var
	bite_started = true
	Engine.time_scale = 0.5
	possession_timer.start(possession_time_threshold)

func handlePossessionDeath(spawn_position) -> void:
	FeedbackHandler.warp()
	current_possession.queue_free()
	GameState.state = GameState.CONTROLLING_PLAYER
	var current_scene = get_tree().get_current_scene()
	var player_instance = PLAYER_SCENE.instance()
	GameState.player = player_instance
	current_scene.add_child(player_instance)
	InputHandler.current_actor = player_instance
	FeedbackHandler.current_camera = player_instance.camera2D
	player_instance.position = spawn_position
	bite_box = player_instance.bite_box
	player_instance.camera2D.make_current()

func possessNewEntity() -> void:
	var areas = bite_box.get_overlapping_areas()
	if areas:
		for area in areas:
			if area.get_name() == "EnemyBiteBox":
				var parent = area.get_parent()
				if parent.state == parent.STUNNED:
					if is_instance_valid(parent.get_node("ButtonQ")):
						parent.get_node("ButtonQ").queue_free()
					current_possession = parent
					possessedNPC = parent
					GameState.state = GameState.CONTROLLING_NPC
					parent.camera2D.make_current()
					parent.health = parent.max_health
					parent.attack_started = false
					parent.attack_landed = false
					parent.target_actor = null
					bite_box = area
					InputHandler.current_actor = parent
					FeedbackHandler.current_camera = parent.camera2D
					GameState.player.queue_free()
					parent.state = parent.IDLE
					break

func _physics_process(_delta):
	if bite_started and Input.is_action_just_released('bite'):
		InputHandler.mute_inputs = false
		Engine.time_scale = 1
		bite_started = false
		possession_timer.stop()
		current_possession = null
