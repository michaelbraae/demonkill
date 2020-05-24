extends Node2D

class_name TelegraogedAOE

onready var abilityBody = $AbilityBody
onready var telegraphSprite = $TelegraphSprite

var target_vector

# telegraphedAOEs should be able to stack;
#	ie: multiple AOEs can be fired at once. and an effect should play.

# perhaps and AbilityHandler class could control this.

# the aiming should be relative to the caster
#	not necessarily the abilities position

# the ability body can be active before the telegraph appears.

# move the TelegraphSprite to the target vector then play.

# move the AbilityBody toward the target vector at the variable speed rate

# Once the abilityBody reaches the target vector. Stop playing the telegraph sprite

# The Area2D should only be hitting the player when it's reached the location

# The on hit animation should then play.

# after that the AOE animation should play if there is one.
