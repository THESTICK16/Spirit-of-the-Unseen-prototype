extends TileMap
## This scene implements the "switch_struck" 'interface' pattern
## Must include the switch_struck function

## The amount by which the map will rotate by default
export var default_rotation := 90

signal rotated(degrees)

func _ready():
	if not is_in_group("RotatingRooms"):
		add_to_group("RotatingRooms")

func rotate_room(degrees := 90):
	if degrees % 90 == 0:
		rotation_degrees += degrees

## @interface
## ALL SCENES AFFECTED BY SWITCHES SCENES MUST CONTAIN THIS METHOD!
## This method should call the method that controls the behavior for the object when a switch is struck
## There is an optional parameter for each base data type and an optional parameter for miscelaneous data types
## Use these parameters as needed for function logic
func switch_struck(_param_int := 0, _param_float := 0, _param_string := "", _param_char := '', _param_bool := false, _param_unspecified_type := null):
	if _param_int == 0 or _param_int % 90 != 0:
		rotate_room()
	else:
		rotate_room(_param_int)
	
#func _unhandled_input(event): #FIXME!
#	if Input.is_action_just_pressed("ui_accept"):
#		rotate_room()
