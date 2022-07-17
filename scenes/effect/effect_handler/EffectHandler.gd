extends Node2D

class_name EffectHandler

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
