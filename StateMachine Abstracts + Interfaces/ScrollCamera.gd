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
	player.move_and_slide(25 * player.direction)


## Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
##@param _msg an optional dictionary option used for states that need initialization
##@override
func enter(_msg := {}) -> void:
	player.animation_state.travel("Idle")
	scroll_camera(_msg.get("area"))
	player.set_collision_mask_bit(13, false)


## Virtual function. Called by the state machine before changing the active state. Use this function
## to clean up the state.
##@override
func exit() -> void:
	pass

func scroll_camera(_area):
	if _area.get_parent() is TileMap:
		var camera = player.camera
		
		var new_limits : Dictionary = camera.get_new_extents(_area.get_parent())
		for limit in new_limits:
			player.tween.interpolate_property(camera, limit, camera.get(limit), new_limits.get(limit), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		
		player.tween.start()
		yield(player.tween, "tween_all_completed")
		player.set_collision_mask_bit(13, true)
		
	state_machine.transition_to("Idle")
