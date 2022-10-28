extends PlayerState

var bomb_button : String
var spirit_bomb : KinematicWeapon
var max_range := 100
## The resource scene for the spirit bomb
var spirit_bomb_resource : SpiritItem

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
	if spirit_bomb != null:
		if Input.is_action_pressed(bomb_button) and spirit_bomb.global_position.distance_to(spirit_bomb.start_position) <= spirit_bomb.max_range:
			if spirit_bomb != null:
#				spirit_bomb.global_position += spirit_bomb.start_direction * (spirit_bomb.speed * _delta)
				spirit_bomb.slide(_delta)
			#make the bomb position move while the button is held!
			else:
				state_machine.transition_to("Idle")
			
		elif not Input.is_action_pressed(bomb_button): # or spirit_bomb.global_position.distance_to(spirit_bomb.start_position) > spirit_bomb.max_range:
			if spirit_bomb != null:
				spirit_bomb.timer.start()
				spirit_bomb = null
			state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Idle")


## Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
##@param _msg an optional dictionary option used for states that need initialization
##@override
func enter(_msg := {}) -> void:
	spirit_bomb_resource = player.equipment.get_item_resource("SpiritBomb")
	bomb_button = player.equipped_items.get_equipped_button(player.equipment.get_item_resource("SpiritBomb"))
	_spirit_bomb()
	player.velocity = Vector2.ZERO #Put this so it gradually moves to zero in the physics process so it won't freeze the player if the button is pressed while a bomb is already out


## Virtual function. Called by the state machine before changing the active state. Use this function
## to clean up the state.
##@override
func exit() -> void:
	spirit_bomb_resource = null
	spirit_bomb = null
	bomb_button = ""
	
func _spirit_bomb():
	if player.can_use_spirit_attack and player.stats.has_spirit_energy():
		spirit_bomb = player.equipment.get_item_field("SpiritBomb", Item.SCENE).instance()
		max_range = spirit_bomb.max_range
		spirit_bomb.user = player
		spirit_bomb.global_position = player.global_position #player.ranged_weapon_spawn_position.global_position
		spirit_bomb.start_direction = player.direction
		get_tree().current_scene.add_child(spirit_bomb) #.current_scene.add_child(spirit_bomb)
		player.stats.spirit_energy -= spirit_bomb_resource.get_item_field(SpiritItem.SPIRIT_COST)
		player.can_use_spirit_attack = false #Set this back to true when the bomb explodes from the bomb script!!!
