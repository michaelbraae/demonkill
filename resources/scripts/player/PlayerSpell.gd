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

func castRangedSpell(spell: Dictionary) -> void:
	var spell_instance = spell["scene"].instance()
	spell_instance.setCollideWithEnemies()
	spell_instance.target_vector = getAttackDirection()
	spell_instance.position = position
	get_tree().get_root().add_child(spell_instance)

func castMeleeSpell(spell: Dictionary) -> void:
	next_spell = spell

func castSpell(slot_key: int) -> void:
	var spell_to_cast = SPELL_SLOTS[str(slot_key)]
	if spell_to_cast:
		match spell_to_cast["type"]:
			"ranged":
				castRangedSpell(spell_to_cast)
			"melee":
				castMeleeSpell(spell_to_cast)
		if spell_to_cast["count"] <= 1:
			SPELL_SLOTS[str(slot_key)] = {}
		else:
			SPELL_SLOTS[str(slot_key)]["count"] -= 1
	else:
		print("No spell in slot!")
	updateSpellState(SPELL_SLOTS)

# certain spells could prioritize slots, or maybe..
# certain spells can ONLY go in particular slots 
