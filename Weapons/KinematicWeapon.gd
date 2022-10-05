##The base class that all wepon types inherit from
class_name KinematicWeapon
extends KinematicBody2D

## The different types a weapon can be
enum weapon_types {
	RANGED,
	CLOSE,
	#SPIRIT,
	AREA_OF_EFFECT
}

## The name of the weapon
export var weapon_name : String
##The type of weapon that this is (i.e. 'ranged', 'special', 'close'
export (String, "RANGED", "CLOSE", "AREA_OF_EFFECT") var weapon_class
## If true, this weapon is a spirit weapon/ability
export var spirit_weapon := false
#export (weapon_types) var weapon_class
##The amount of damage the weapon will do
export var damage := 0.0
##Whether or not the weapon will stun enemies it hits
export var stuns := false
##The speed at which the weapon will travel (if applicable)
export var speed := 0
##The amount by which the body struck by the weapon will be pushed back
export var knockback := 0
### If true, using this item will consume spirit gauge energy
#export var spirit_item := false
### If this is a spirit item, the amount of spirit energy it will consume upon use
#export var spirit_energy_cost := 0
##The node path of the creature that is using the weapon (should be set by the user)  (optional)
var user
##The position at which the weapon starts
onready var start_position = global_position
##The starting direction of the weapon (typically set to the user's direction by the user)
var start_direction = Vector2.ZERO
##The velocity vector (direction times speed) of the weapon (if applicable)
var velocity : Vector2
##The hitbox of the weapon
onready var hitbox = $HitBox
##The animated_sprite of the weapon (optional)
onready var animated_sprite = $AnimatedSprite

func _ready():
	if hitbox != null:
		hitbox.damage = damage
		hitbox.knockback = knockback
		hitbox.stuns = stuns

##The function called when the weapon collides with an enemy. This determines what the weapon will do (i.e. stun, damage, status effect, etc.)
##@override
func effect():
	pass
	
## Returns the value in radians that the weapon should rotate based on its starting direction (assumes DOWN is 0 degrees)
func set_rotation_direction() -> float:
	match start_direction:
		Vector2.UP:
			return deg2rad(180)
		Vector2.DOWN:
			return deg2rad(0)
		Vector2.LEFT:
			return deg2rad(90)
		Vector2.RIGHT:
			return deg2rad(-90)
		
	return 0.0
	
func fix_direction():
	if start_direction.x != 0 and start_direction.y != 0:
		if start_direction == Vector2(1,1).normalized():
			return Vector2.DOWN
		if start_direction == Vector2(-1,1).normalized():
			return Vector2.DOWN
		if start_direction == Vector2(1,-1).normalized():
			return Vector2.UP
		if start_direction == Vector2(-1,-1).normalized():
			return Vector2.UP
	else:
		return start_direction
