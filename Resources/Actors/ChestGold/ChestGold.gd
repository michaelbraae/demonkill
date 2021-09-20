extends StaticBody2D

enum {
	CLOSED,
	OPENING,
	OPEN,
	CLOSING
}

var state = CLOSED

func _ready() -> void:
	$Area2D.connect("body_entered", self, "on_body_entered")
	$Area2D.connect("body_exited", self, "on_body_exited")
	$AnimatedSprite.connect("animation_finished", self, "on_animation_finished")

func on_body_entered(body) -> void:
	if body == GameState.player:
		$OpenPrompt.visible = true

func on_body_exited(body) -> void:
	if body == GameState.player:
		$OpenPrompt.visible = false

func _process(_delta) -> void:
	if Input.is_action_just_pressed("interact"):
		match state:
			CLOSED:
				state = OPENING
				$AnimatedSprite.play("opening")
			OPEN:
				state = CLOSING
				$AnimatedSprite.play("closing")

func on_animation_finished() -> void:
	match state:
		OPENING:
			state = OPEN
			$AnimatedSprite.play("open")
		CLOSING:
			state = CLOSED
			$AnimatedSprite.play("closed")
