extends Node

var knocked_back = false
var knock_back_vector
var knock_back_speed = 300
var knock_back_speed_current = getKnockBackSpeed()
var knock_back_decay

func setKnockedBack(is_knocked_back : bool) -> void:
	knocked_back = is_knocked_back

func getKnockedBack() -> bool:
	return knocked_back

func setKnockBackVector(knock_vector : Vector2) -> void:
	knock_back_vector = knock_vector

func getKnockBackVector() -> Vector2:
	return knock_back_vector

func setKnockBackSpeed(speed : int) -> void:
	knock_back_speed = speed

func getKnockBackSpeed() -> int:
	return knock_back_speed

func setKnockBackSpeedCurrent(current_speed : int) -> void:
	knock_back_speed_current = current_speed

func getKnockBackSpeedCurrent() -> int:
	return knock_back_speed_current

func setKnockBackDecay(decay : int) -> void:
	knock_back_decay = decay

func getKnockBackDecay() -> int:
	return knock_back_decay

func getKnockBackProcessVector() -> Vector2:
	if getKnockBackSpeedCurrent() < 10:
		setKnockBackSpeedCurrent(getKnockBackSpeed())
		setKnockedBack(false)
	knock_back_speed_current -= getKnockBackDecay()
	return getKnockBackVector().normalized() * knock_back_speed_current

func knockBack(
	hit_direction : float,
	knock_back_speed_var : int,
	knock_back_decay_var : int
) -> void:
	setKnockedBack(true)
	setKnockBackSpeed(knock_back_speed_var)
	setKnockBackDecay(knock_back_decay_var)
	setKnockBackVector(Vector2(cos(hit_direction), sin(hit_direction)))


