#Comes from the example found at https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/

# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.

#to properly use, have all State scripts extend PlayerState instead of State
class_name PlayerState
extends State

# Typed reference to the player node.
var player: Player = null


func _ready() -> void:
	# The states are children of the `Player` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	yield(owner, "ready")
	# The `as` keyword casts the `owner` variable to the `Player` type.
	# If the `owner` is not a `Player`, we'll get `null`.
	player = owner.owner as Player
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than `Player.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(player != null)
	
func check_face_buttons():
	if Input.is_action_just_pressed("a"):
		if player.interacting:
			if player.interactable_object != null:
				if player.interactable_object.has_method("get_interactable_type"):
					var _interactable_type = player.interactable_object.get_interactable_type()
				if player.interactable_object.has_method("interact"):
					player.interactable_object.interact()
#			if player.interactable_object != null: #Put all of this code in the dialogue state and just call to change to the dialogue state (or a different interactable state like "lift" or something
#				if player.interactable_object.has_method("get_interactable_type"):
#					var _interactable_type = player.interactable_object.get_interactable_type()
#					state_machine.transition_to("Dialogue", {"interactable": player.interactable_object})
		else:
			state_machine.transition_to("UseItem", {"item": equipped_items.get_equipped_item_resource(ControllerButtons.A)})
	if Input.is_action_just_pressed("b"):
		state_machine.transition_to("UseItem", {"item": equipped_items.get_equipped_item_resource(ControllerButtons.B)}) #.stats.equipped_item_b})
	if Input.is_action_just_pressed("x"):
		state_machine.transition_to("UseItem", {"item": equipped_items.get_equipped_item_resource(ControllerButtons.X)})
	if Input.is_action_just_pressed("y"):
		state_machine.transition_to("UseItem", {"item": equipped_items.get_equipped_item_resource(ControllerButtons.Y)})
		
	if Input.is_action_just_pressed("pause") and not get_tree().paused:
		state_machine.transition_to("Pause")
