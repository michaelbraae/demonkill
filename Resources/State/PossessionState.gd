extends Node

const PLAYER_SCENE = preload('res://Resources/Actors/Player/Player.tscn')

onready var GameState = get_node('/root/GameState')
onready var FeedbackHandler = get_node('/root/FeedbackHandler')
onready var InputHandler = get_node('/root/InputHandler')

var bite_box

var current_possession

var possessedNPC

var possession_candidate

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
		possessNewEntity(current_possession)

func initiateBite(current_possession_var):
	InputHandler.mute_inputs = true
	current_possession = current_possession_var
	bite_started = true
	Engine.time_scale = 0.5
	possession_timer.start(possession_time_threshold)

func handlePossessionDeath(spawn_position) -> void:
	FeedbackHandler.warp()
	possessedNPC.queue_free()
	GameState.state = GameState.CONTROLLING_PLAYER
	var current_scene = get_tree().get_current_scene()
	var player_instance = PLAYER_SCENE.instance()
	current_scene.add_child(player_instance)
	InputHandler.current_actor = player_instance
	player_instance.position = spawn_position
	bite_box = player_instance.bite_box
	player_instance.camera2D.make_current()

func possessNewEntity(current_possession_var) -> void:
	var areas = bite_box.get_overlapping_areas()
	if areas:
		for area in areas:
			if area.get_name() == 'EnemyBiteBox':
				var parent = area.get_parent()
				if parent.state == parent.STUNNED:
					GameState.state = GameState.CONTROLLING_NPC
					parent.npc_camera.make_current()
					parent.bite_button.hide()
					parent.health = parent.MAX_HEALTH
					parent.attack_started = false
					parent.attack_landed = false
					possessedNPC = parent
					bite_box = area
					InputHandler.current_actor = parent
					current_possession_var.queue_free()
					break

func _physics_process(_delta):
	if bite_started and Input.is_action_just_released('bite'):
		InputHandler.mute_inputs = false
		Engine.time_scale = 1
		bite_started = false
		possession_timer.stop()
