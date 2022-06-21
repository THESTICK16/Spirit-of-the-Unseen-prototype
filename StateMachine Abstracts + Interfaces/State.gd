#Comes from the example found at https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/

# Virtual base class for all states.
#aka Abstract Class
class_name State
extends Node

## Reference to the state machine, to call its `transition_to()` method directly.
## That's one unorthodox detail of our state implementation, as it adds a dependency between the
## state and the state machine objects, but we found it to be most efficient for our needs.
## The state machine node will set it.
var state_machine = null

var equipment = Equipment
var equipped_items = EquippedItems

## Virtual function. Receives events from the `_unhandled_input()` callback.
##@param _event the InputEvent to be handled
##@override
func handle_input(_event: InputEvent) -> void:
	pass
	
## Virtual function. Corresponds to the `_process()` callback.
##@param _delta Delta
##@override
func update(_delta: float) -> void:
	pass


## Virtual function. Corresponds to the `_physics_process()` callback.
##@param _delta Delta
##@override
func physics_update(_delta: float) -> void:
	pass


## Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
##@param _msg an optional dictionary option used for states that need initialization
##@override
func enter(_msg := {}) -> void:
	pass


## Virtual function. Called by the state machine before changing the active state. Use this function
## to clean up the state.
##@override
func exit() -> void:
	pass
