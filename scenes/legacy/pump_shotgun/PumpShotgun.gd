extends RotatingWeapon

const SPREAD = 0.2

const MAGAZINE_SIZE = 5
var bullets_in_clip = MAGAZINE_SIZE

var total_rounds = 15

var can_fire = true

var spread_rng = RandomNumberGenerator.new()

func fire(attack_direction : Vector2) -> void:
	if can_fire:
		instantiateProjectiles(attack_direction)

func instantiateProjectiles(attack_direction : Vector2) -> void:
	for random_trajectory in getRandomTrajectories(attack_direction):
		pass

func getRandomTrajectories(attack_direction : Vector2) -> Array:
	var trajectories = []
	for _n in range(4):
		trajectories.append(generateRandomTrajectory(attack_direction))
	return trajectories

func generateRandomTrajectory(attack_direction : Vector2) -> Vector2:
	var spread_x
	var spread_y
	spread_rng.randomize()
	spread_x = attack_direction.x + spread_rng.randf_range(-SPREAD, SPREAD)
	spread_y = attack_direction.y + spread_rng.randf_range(-SPREAD, SPREAD)
	return Vector2(spread_x, spread_y)
