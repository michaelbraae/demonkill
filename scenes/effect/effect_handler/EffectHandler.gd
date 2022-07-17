extends Node2D

class_name EffectHandler

# should have a number of functions to be called

# Effect types
enum {
	DAMAGE,
	HEAL,
	POISON,
	BURN,
	FREEZE,
	ON_DEATH
}

func applyEffect(effect: Effect) -> void:
	match effect.effect_type:
		DAMAGE:
			damageEffect(effect)
		HEAL:
			healEffect(effect)
		POISON:
			poisonEffect(effect)

func damageEffect(effect: DamageEffect) -> void:
	owner.damage(effect.damage)

func healEffect(effect: HealEffect) -> void:
	pass

func poisonEffect(effect: PoisonEffect) -> void:
	pass

#func burnEffect(effect: BurnEffect) -> void:
#	pass
#
#func freezeEffect(effect: FreezeEffect) -> void:
#	pass
#
#func onDeathEffect(effect: OnDeathEffect) -> void:
#	pass

func _ready() -> void:
	# use owner to get a reference to the current nodes root parent
	#(not the whole tree)
	owner.get_name()
