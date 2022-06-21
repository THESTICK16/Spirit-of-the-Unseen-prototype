extends PlayerState

var drawn_bow_move_speed = 100
var bow_button : String
var arrow_resource : ConsumableItem

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
	if Input.is_action_pressed(bow_button):
		player.velocity = player.velocity.move_toward(player.input_vector * player.stats.MAX_SPEED, player.stats.acceleration * _delta)
		player.velocity = player.velocity.clamped(drawn_bow_move_speed)
		player.velocity = player.move_and_slide(player.velocity)
		
	elif not Input.is_action_pressed(bow_button):
		arrow()
		state_machine.transition_to("Idle")


## Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
##@param _msg an optional dictionary option used for states that need initialization
##@override
func enter(_msg := {}) -> void:
	arrow_resource = player.equipment.get_item_resource("Arrow")
	bow_button = player.equipped_items.get_equipped_button(player.equipment.get_item_resource("Arrow")) #To fix this error uncomment the first part. This is just to remind me that i need to fix it so holdong down the arrow button goes to bow aiming movement


## Virtual function. Called by the state machine before changing the active state. Use this function
## to clean up the state.
##@override
func exit() -> void:
	pass
	
func arrow():
	if player.can_fire_arrow and arrow_resource.can_use():
		var arrow = player.equipment.get_item_field("Arrow", Item.SCENE).instance()
		arrow.user = player
		arrow.start_direction = player.direction
		arrow.global_position = player.ranged_weapon_spawn_position.global_position
		get_tree().root.add_child(arrow)
		arrow_resource.decrement_stock()
		player.can_fire_arrow = false
		yield(get_tree().create_timer(1), "timeout")
		player.can_fire_arrow = true
