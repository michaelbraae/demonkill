extends PlayerPossession

class_name PlayerSpell

const SPELL_SLOTS = {
	"0": {},
	"1": {},
	"2": {},
	"3": {},
}

func updateSpellState(spells : Dictionary) -> void:
	PlayerState.SPELLS = spells
	GameState.player_ui.updateSpellUI(spells)

func pickupSpell(spell : Dictionary):
	var in_slot = false
	for slot in SPELL_SLOTS:
		if SPELL_SLOTS[slot] and SPELL_SLOTS[slot]["name"] == spell["name"]:
			SPELL_SLOTS[slot]["count"] += 1
			in_slot = true
			break
	if !in_slot:
		for slot in SPELL_SLOTS:
			if !SPELL_SLOTS[slot]:
				SPELL_SLOTS[slot] = spell
				break
	updateSpellState(SPELL_SLOTS)

func castSpell(slot_key: int) -> void:
	if SPELL_SLOTS[str(slot_key)]:
		print("castSpell: ", SPELL_SLOTS[str(slot_key)])
		var spell_instance = SPELL_SLOTS[str(slot_key)]["scene"].instance()
#		spell_instance.collision
		spell_instance.setCollideWithEnemies()
		spell_instance.target_vector = getAttackDirection()
		spell_instance.position = GameState.player.position
		get_tree().get_root().add_child(spell_instance)
		if SPELL_SLOTS[str(slot_key)]["count"] <= 1:
			SPELL_SLOTS[str(slot_key)] = {}
		else:
			SPELL_SLOTS[str(slot_key)]["count"] -= 1
	else:
		print("No spell in slot!")
	updateSpellState(SPELL_SLOTS)

# certain spells could prioritize slots, or maybe..
# certain spells can ONLY go in particular slots 
