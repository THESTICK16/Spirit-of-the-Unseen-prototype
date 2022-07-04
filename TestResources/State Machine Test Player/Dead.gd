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
	player.velocity = player.velocity.move_toward(Vector2.ZERO, player.stats.friction * _delta)
	if player.velocity != Vector2.ZERO:
		player.velocity = player.move_and_slide(player.velocity)


## Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
##@param _msg an optional dictionary option used for states that need initialization
##@override
func enter(_msg := {}) -> void:
	player.is_dead = true
	player.animation_state.travel("die")
	player.hurtbox.set_deferred("monitorable", false)
	player.hurtbox.set_deferred("monitoring", false)
	player.get_node("CollisionShape2D").set_deferred("monitorable", false)
	var camera = player.camera
	camera.position = camera.global_position
	player.remove_child(camera)
	get_tree().root.add_child(camera)
	yield(get_tree().create_timer(3), "timeout")
	TransitionController.change_to_new_scene("res://UI/Menus/GameOver/GameOverScreen.tscn")


## Virtual function. Called by the state machine before changing the active state. Use this function
## to clean up the state.
##@override
func exit() -> void:
	pass
