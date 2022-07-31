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
			damage_effect(effect)
		HEAL:
			heal_effect(effect)
		POISON:
			poison_effect(effect)
		KNOCKBACK:
			knockback_effect(effect)
		MANA_REGEN:
			mana_regen_effect(effect)

func damage_effect(effect: DamageEffect) -> void:
	owner.damage(effect.damage)

func heal_effect(_effect: HealEffect) -> void:
	pass

func poison_effect(effect: PoisonEffect) -> void:
	$PoisonHandler.beginEffect(effect)

func knockback_effect(effect: KnockbackEffect) -> void:
	owner.knockBack(effect.hit_direction, effect.speed, effect.decay)

func mana_regen_effect(effect: ManaRegenEffect) -> void:
	PlayerState.addMana(effect.mana_regen_amount)
