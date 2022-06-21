#class_name State
extends Node

var state_name : String setget , get_name
##The owner of this state To be assigned from the creature's script
var creature : Creature
##the Stats node of the creature. To be assigned from the creature's script
var stats
signal state_changed(new_state)

func _ready():
	yield(owner, "ready")
#	creature = owner as Creature
	assert(creature != null)
	
## Virtual function. Corresponds to the `_process()` callback.
func _update(delta):
	pass

## Virtual function. Corresponds to the `_physics_process()` callback.
func _physics_update(delta):
	pass

func get_name():
	return state_name
	
	
# Virtual function. Called by the state machine upon changing the active state.
##This will initialize the player into the new state
##If using an animation tree state machine, this function should enter into that new state
func enter():
	pass
	
# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state. i.e. reset variables
func exit():
	pass

#States to include for player or enemies or both:
#move, idle, attack/use_item, stunned, dead
