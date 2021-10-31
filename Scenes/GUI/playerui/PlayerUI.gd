extends CanvasLayer

onready var GameState = get_node('/root/GameState')
onready var PlayerState = get_node('/root/PlayerState')
onready var PossessionState = get_node('/root/PossessionState')

onready var label = get_node('Label')

var health_current
var max_health

func _physics_process(_delta):
	if GameState.state == GameState.CONTROLLING_NPC and is_instance_valid(PossessionState.current_possession):
		health_current = PossessionState.current_possession.health
		max_health = PossessionState.current_possession.max_health
	else:
		health_current = PlayerState.health
		max_health = PlayerState.max_health
	label.set_text(str(health_current, '/', max_health))

func updateSpellUI(spells: Dictionary) -> void:
	var slots = GameState.player_ui.get_node("SpellSlotsUI").get_children()
	print('SpellSlotsUI.get_children()', slots)
	for i in range(len(slots)):
		print('i: ', i)
		if spells[str(i)]:
			print('spell_i:', i, spells[str(i)])
#			print(slots[i].get_name())
			slots[i].set_text(spells[str(i)]["name"])
		else:
			slots[i].set_text('Slot' + str(i + 1))
