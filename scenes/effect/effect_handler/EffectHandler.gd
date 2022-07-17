extends Node2D

class_name EffectHandler

## should have a number of functions to be called

func applyEffect(effect: Node2D) -> void:
	pass

func _ready() -> void:
	# use owner to get a reference to the current nodes root parent
	#(not the whole tree)
	owner.get_name()
