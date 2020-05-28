extends Node

var knocked_back = false
var knock_back_vector

const KNOCK_BACK_SPEED = 300
var knock_back_speed_current = KNOCK_BACK_SPEED

func getKnockBackProcessVector() -> Vector2:
	if knock_back_speed_current < 10:
		knock_back_speed_current = 300
		setKnockedBack(false)
	knock_back_speed_current -= 15
	return getKnockBackVector().normalized() * knock_back_speed_current

#	velocity = getKnockBackVector()
#	knock_back_speed_current -= 15
#	velocity = velocity.normalized() * knock_back_speed_current
#
func knockBack(hit_direction : float) -> void:
	setKnockedBack(true)
	setKnockBackVector(Vector2(cos(hit_direction), sin(hit_direction)))

func setKnockedBack(is_knocked_back : bool) -> void:
	knocked_back = is_knocked_back

func getKnockedBack() -> bool:
	return knocked_back

func setKnockBackVector(knock_vector : Vector2) -> void:
	knock_back_vector = knock_vector

func getKnockBackVector() -> Vector2:
	return knock_back_vector
