extends Node

var state

var current_weapon
var previous_weapon

enum {
	RUNNING,
	IDLE,
	MELEE,
	CASTING,
	FIRING,
	ROLLING,
	HIT,
}

const PumpShotgun = {
	"name": "PumpShotgun",
	"path": "res://Resources/Weapons/PumpShotgun/PumpShotgun.tscn",
	"iconPath" : "",
}

func _ready():
	current_weapon = PumpShotgun

func setState(state_var : int) -> void:
	state = state_var

func getState() -> int:
	return state

func setCurrentWeapon(NewWeapon : Dictionary):
	current_weapon = NewWeapon

func getCurrentWeapon() -> Dictionary:
	return current_weapon

func setPreviousWeapon(PreviousWeapon : Dictionary):
	previous_weapon = PreviousWeapon

func getPreviousWeapon() -> Dictionary:
	return previous_weapon

# to alternate, changeWeapon(getPreviousWeapon())
func changeWeapon(NewWeapon : Dictionary) -> void:
	setPreviousWeapon(getCurrentWeapon())
	setCurrentWeapon(NewWeapon)

