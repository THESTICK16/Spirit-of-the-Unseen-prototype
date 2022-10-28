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
	_spirit_gravity()


## Virtual function. Called by the state machine before changing the active state. Use this function
## to clean up the state.
##@override
func exit() -> void:
	pass


func _spirit_gravity():
	if player.can_use_spirit_attack and player.stats.has_spirit_energy():
		player.velocity = Vector2.ZERO
		var spirit_gravity_resource: SpiritItem = player.equipment.get_item_resource("SpiritGravity")
		var spirit_gravity = spirit_gravity_resource.get_item_field(Item.SCENE).instance() # player.equipment.get_item_field("SpiritGravity", Item.SCENE).instance()
		spirit_gravity.user = player
		spirit_gravity.global_position = player.global_position #player.ranged_weapon_spawn_position.global_position
		spirit_gravity.start_direction = player.direction
		get_tree().current_scene.add_child(spirit_gravity) #.current_scene.add_child(spirit_bomb)
		player.stats.spirit_energy -= spirit_gravity_resource.get_item_field(SpiritItem.SPIRIT_COST)
		player.can_use_spirit_attack = false #Set this back to true when the bomb explodes from the bomb script!!!
	state_machine.transition_to("Idle")
