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
	if player.input_vector == Vector2.ZERO:
		state_machine.transition_to("Idle")
		
	else:
		player.direction = player.input_vector.normalized()
		player.ranged_weapon_spawn_position.position = player.direction * 32
		player.interactable_detection_area.position = player.direction * 20
		player.animation_tree.set("parameters/Idle/blend_position", player.direction)
		player.animation_tree.set("parameters/Move/blend_position", player.direction)
		player.animation_tree.set("parameters/Attack/blend_position", player.direction)
		
	check_face_buttons()
#	if Input.is_action_just_pressed("a"):
#		state_machine.transition_to("UseItem", {"item": player.stats.equipped_item_a})
#	if Input.is_action_just_pressed("b"):
#		state_machine.transition_to("UseItem", {"item": player.stats.equipped_item_b})
#	if Input.is_action_just_pressed("x"):
#		state_machine.transition_to("UseItem", {"item": player.stats.equipped_item_x})
#	if Input.is_action_just_pressed("y"):
#		state_machine.transition_to("UseItem", {"item": player.stats.equipped_item_y})
	
	player.velocity = player.velocity.move_toward(player.input_vector * player.stats.MAX_SPEED, player.stats.acceleration * _delta)
#	player.velocity += player.input_vector * player.stats.acceleration
	player.velocity = player.velocity.clamped(player.stats.MAX_SPEED)
	player.velocity = player.move_and_slide(player.velocity)	


## Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
##@param _msg an optional dictionary option used for states that need initialization
##@override
func enter(_msg := {}) -> void:
	player.animation_state.travel("Move")


## Virtual function. Called by the state machine before changing the active state. Use this function
## to clean up the state.
##@override
func exit() -> void:
	pass
