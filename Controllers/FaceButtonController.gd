extends Resource

var player = PlayerStats.player

func check_face_buttons():
	if Input.is_action_just_pressed("a"):
		if player.interacting:
			if player.interactable_object != null: #Put all of this code in the dialogue state and just call to change to the dialogue state (or a different interactable state like "lift" or something
				if player.interactable_object.has_method("get_interactable_type"):
					var _interactable_type = player.interactable_object.get_interactable_type()
				if player.interactable_object.has_method("interact"):
					player.interactable_object.interact()
#		else:
#			state_machine.transition_to("UseItem", {"item": player.get_equipped_item(ControllerButtons.A)})
#	if Input.is_action_just_pressed("b"):
#		state_machine.transition_to("UseItem", {"item": player.get_equipped_item(ControllerButtons.B)}) #.stats.equipped_item_b})
#	if Input.is_action_just_pressed("x"):
#		state_machine.transition_to("UseItem", {"item": player.get_equipped_item(ControllerButtons.X)})
#	if Input.is_action_just_pressed("y"):
#		state_machine.transition_to("UseItem", {"item": player.get_equipped_item(ControllerButtons.Y)})
#
#	if Input.is_action_just_pressed("pause") and not PauseController.is_paused():
#		state_machine.transition_to("Pause")
