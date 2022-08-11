extends Effect

class_name DotEffect

export var effect_duration: float

export var tick_rate: float

export var damage: int

# the effect script should be able to handle what happens 
# if the player is already poisoned

# eg:
# Apply poison effect to the Character, the character is already poisoned.
# Character asks the poisonEffect, what to do if already poisoned
# The PoisonEffect then returns the result. IE:
# this logic should not reset the original poison stack's duration
# Poison effect with X duration, X stacks, X Damage per tick, X Tick per second


# effect handler, should be able to say what happens when a character dies
# ie: onDeath() -> EffectHandler.get_on_death_effects() if there are any
