extends PlayerPossession

class_name PlayerSpell

const SPELL_SLOTS = {
	"0": {},
	"1": {},
	"2": {},
	"3": {},
}

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
	PlayerState.SPELLS = SPELL_SLOTS
	GameState.player_ui.updateSpellUI(SPELL_SLOTS)

# 4 spell slots

# walking over a pickupability adds it to the next empty slot

# picking up a duplicate abilty adds +1 to the count of that spell

# casting an ability removes it from the slot or -1 if count > 1
# or increases intensity??

# certain spells could prioritize slots, or maybe..
# certain spells can ONLY go in particular slots 

# need to play test this probably, kinda hard to know how it will feel
