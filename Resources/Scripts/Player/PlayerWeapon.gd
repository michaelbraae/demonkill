extends PlayerNavigation

class_name PlayerWeapon

var weapon_slots_script = load("res://Resources/State/WeaponSlots.gd")
var WeaponSlots

var current_weapon
var weapon_equipped

func _ready():
	var current_weapon_config = PlayerState.getCurrentWeapon()
	var weapon_scene = load(current_weapon_config["path"])
	current_weapon = weapon_scene.instance()
	current_weapon.set_name("CurrentWeapon")
	add_child(current_weapon)

func changeWeapon(NewWeapon : Dictionary) -> void:
	PlayerState.changeWeapon(NewWeapon)

func _process(_delta):
	if Input.is_action_just_pressed("weapon_slot_1"):
		changeWeapon(WeaponSlots.getWeaponSlot(1))
	if Input.is_action_just_pressed("weapon_slot_2"):
		changeWeapon(WeaponSlots.getWeaponSlot(2))
	if Input.is_action_just_pressed("weapon_slot_3"):
		changeWeapon(WeaponSlots.getWeaponSlot(3))
	if Input.is_action_just_pressed("weapon_slot_4"):
		changeWeapon(WeaponSlots.getWeaponSlot(4))
	if Input.is_action_just_pressed("weapon_slot_2"):
		changeWeapon(WeaponSlots.getWeaponSlot(5))
	if Input.is_action_just_pressed("weapon_slot_2"):
		changeWeapon(WeaponSlots.getWeaponSlot(6))
	if Input.is_action_just_pressed("weapon_slot_2"):
		changeWeapon(WeaponSlots.getWeaponSlot(7))
	if Input.is_action_just_pressed("weapon_slot_2"):
		changeWeapon(WeaponSlots.getWeaponSlot(8))

# if it's equipped, it should rotate as usual

# if the player hits melee attack, the gun should be unequipped

# shooting the weapon should equip it.

# this can be empty - nothing equipped?
# maybe two hands? floating

# if unequipped, the weapon should rest on the players back
