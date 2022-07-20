extends Node2D

class_name EffectHandler

# Effect types
enum {
	DAMAGE,
	HEAL,
	POISON,
	BURN,
	FREEZE,
	ON_DEATH,
	KNOCKBACK,
}

func applyEffect(effect: Effect) -> void:
	match effect.effect_type:
		DAMAGE:
			damageEffect(effect)
		HEAL:
			healEffect(effect)
		POISON:
			poisonEffect(effect)
		KNOCKBACK:
			knockbackEffect(effect)

func damageEffect(effect: DamageEffect) -> void:
	owner.damage(effect.damage)

func healEffect(_effect: HealEffect) -> void:
	pass

func poisonEffect(_effect: PoisonEffect) -> void:
	pass

func knockbackEffect(effect: KnockbackEffect) -> void:
	owner.knockBack(effect.hit_direction, effect.speed, effect.decay)
