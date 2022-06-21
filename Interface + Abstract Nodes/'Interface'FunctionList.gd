extends Node

##This is just a list of functions that does not actually get called or used ever.
##It is just a resource for me to copy and face consistent functions that must be used by all types that 'implement' that 'interface'

#-------------------------------------------------------------------------------------------------------------------------------------------------
# Interactable Interface

## @interface
## ALL INTERACTABLE SCENES MUST CONTAIN THIS METHOD!
## Returns the type of interaction that interacting with this object should have
## The return value should be a string of one of the player's states (maybe not, we'll see)
## Return type should be a constant from 'Interactables'
func get_interactable_type() -> String:
	return ""

## @interface
## ALL INTERACTABLE SCENES MUST CONTAIN THIS METHOD!
## Contains the logic for what happens when the player interacts with this object
func interact():
	pass
#-------------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------------------
#Switch Struck Interface


## @interface
## ALL SCENES AFFECTED BY SWITCHES SCENES MUST CONTAIN THIS METHOD!
## This method should call the method that controls the behavior for the object when a switch is struck
## There is an optional parameter for each base data type and an optional parameter for miscelaneous data types
## Use these parameters as needed for function logic
func switch_struck(_param_int := 0, _param_float := 0, _param_string := "", _param_char := '', _param_bool := false, _param_unspecified_type := null):
	pass

#-------------------------------------------------------------------------------------------------------------------------------------------------
