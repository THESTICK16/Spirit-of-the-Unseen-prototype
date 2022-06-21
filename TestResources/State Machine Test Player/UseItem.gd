extends PlayerState

var item

## Virtual function. Receives events from the `_unhandled_input()` callback.
##@param _event the InputEvent to be handled
##@override
func handle_input(_event: InputEvent) -> void:
	pass

## Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
##@param _msg an optional dictionary option used for states that need initialization
##@override
func enter(_msg := {}) -> void:
	player.animation_state.travel("Idle")
	var item_resource = _msg.get("item")
#	print(equipped_items.get_equipped_item_field(ControllerButtons.B, Item.PLAYER_HAS_ITEM)) #FIXME!
	print(item_resource.get_item_field(Item.PLAYER_HAS_ITEM)) #FIXME!
#	print(equipment.get_item_field("Sword", Item.PLAYER_HAS_ITEM)) #FIXME!
	var has_item = equipment.get_item_field(item_resource.get_item_field(Item.NAME), Item.PLAYER_HAS_ITEM) #FIXME!
	print(has_item) #FIXME!
#	if item_resource.get_item_field(Item.PLAYER_HAS_ITEM):
		
	item = _msg.get("item").get_item_field(Item.SCENE)
	
	if item != player.equipment.get_item_field(Item.NULLITEM, Item.SCENE):
		for item_name in player.equipment.all_items:
			if player.equipment.get_item_field(item_name, Item.SCENE) == self.item: #This is giving nullitem and failing to change state
				var next_state_name: String = "Use" + item_name
				if state_machine.has_node(next_state_name):
					state_machine.transition_to(next_state_name) #"Use" + item_name)
					return
				else: break

#	match item:
#		player.Boomerang:
#			boomerang()
#
#		player.Arrow:
#			if player.can_fire_arrow:
#				state_machine.transition_to("UseArrow")
##			arrow()
#				return
#
#		player.Sword:
#			sword()
#
#		player.RotateAttack:
#			rotate_attack()
#
#		player.SpiritBomb:
#			state_machine.transition_to("UseSpiritBomb")
#			return

#	if state_machine.state == self:
	state_machine.transition_to("Idle")


## Virtual function. Called by the state machine before changing the active state. Use this function
## to clean up the state.
##@override
func exit() -> void:
	pass
	
#func sword():
#	var sword = player.Sword.instance()
#	sword.position = player.ranged_weapon_spawn_position.position
#	sword.start_direction = player.direction
##	get_tree().root.add_child(sword)
#	player.add_child(sword)

func boomerang():
	if player.can_throw_boomerang:
		var boomerang = player.Boomerang.instance()
		boomerang.player = player
		boomerang.start_direction = player.direction
		boomerang.global_position = player.ranged_weapon_spawn_position.global_position
		get_tree().root.add_child(boomerang)
		player.can_throw_boomerang = false
		
#func arrow():
#	if player.can_fire_arrow:
#		var arrow = player.Arrow.instance()
#		arrow.user = player
#		arrow.start_direction = player.direction
#		arrow.global_position = player.ranged_weapon_spawn_position.global_position
#		get_tree().root.add_child(arrow)
#		player.can_fire_arrow = false
#		yield(get_tree().create_timer(1), "timeout")
#		player.can_fire_arrow = true
		
func rotate_attack():
	if player.can_use_rotate_attack:
		var rotate_attack = player.RotateAttack.instance()
		rotate_attack.weapon.user = player
		rotate_attack.global_position = player.ranged_weapon_spawn_position.global_position + (player.direction * 100)
		get_tree().root.add_child(rotate_attack)
		player.can_use_spirit_attack = false
		yield(rotate_attack.get_node("DespawnTimer"), "timeout")
		player.can_use_spirit_attack = true
	
	
