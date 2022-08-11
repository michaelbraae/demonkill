extends Control

onready var label = $Label
onready var healthBar = $HealthBar

var health_current
var max_health

func _physics_process(_delta) -> void:
	if GameState.state == GameState.CONTROLLING_NPC and is_instance_valid(PossessionState.current_possession):
		health_current = PossessionState.current_possession.health
		max_health = PossessionState.current_possession.max_health
	else:
		health_current = PlayerState.health
		max_health = PlayerState.max_health
	healthBar.max_value = max_health
	healthBar.value = health_current
	
	$ManaBar.max_value = PlayerState.max_mana
	$ManaBar.value = PlayerState.mana
	
	if is_instance_valid(GameState.player):
		$DashCooldown.text = str(stepify(GameState.player.dash_cooldown_timer.get_time_left(), 0.1))
