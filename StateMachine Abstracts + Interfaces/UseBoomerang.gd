extends PlayerState

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
	boomerang()
	state_machine.transition_to("Idle")


## Virtual function. Called by the state machine before changing the active state. Use this function
## to clean up the state.
##@override
func exit() -> void:
	pass

func boomerang():
	if player.can_throw_boomerang:
		var boomerang = equipment.get_item_field("Boomerang", Item.SCENE).instance()
		boomerang.player = player
		boomerang.start_direction = player.direction
		boomerang.global_position = player.ranged_weapon_spawn_position.global_position
		get_tree().root.add_child(boomerang)
		player.can_throw_boomerang = false
