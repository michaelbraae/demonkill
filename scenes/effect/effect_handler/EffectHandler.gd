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
	MANA_REGEN
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
		MANA_REGEN:
			manaRegenEffect(effect)

func damageEffect(effect: DamageEffect) -> void:
	owner.damage(effect.damage)

func healEffect(_effect: HealEffect) -> void:
	pass

func poisonEffect(effect: PoisonEffect) -> void:
	$PoisonHandler.beginEffect(effect)

func knockbackEffect(effect: KnockbackEffect) -> void:
	owner.knockBack(effect.hit_direction, effect.speed, effect.decay)

func manaRegenEffect(effect: ManaRegenEffect) -> void:
	PlayerState.addMana(effect.mana_regen_amount)
