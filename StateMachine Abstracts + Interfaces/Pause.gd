extends PlayerState

onready var Inventory_Menu = preload("res://UI/Inventory/Inventory.tscn")

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
#	if Input.is_action_just_pressed("pause"):
#		print("pause pressed") #FIXME
#		state_machine.transition_to("Idle")
	pass


## Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
##@param _msg an optional dictionary option used for states that need initialization
##@override
func enter(_msg := {}) -> void:
	print("entered paused") #FIXME
#	get_tree().paused = true
	PauseController.pause()
	inventory()
#	player.inventory_menu.show()
#	if not player.inventory_menu.is_connected("close_inventory", self, "back_to_idle"):
#		player.inventory_menu.connect("close_inventory", self, "back_to_idle")
	


## Virtual function. Called by the state machine before changing the active state. Use this function
## to clean up the state.
##@override
func exit() -> void:
	print("exited paused") #FIXME
#	player.inventory_menu.hide()
#	get_tree().paused = false
	PauseController.unpause()
	
func inventory():
	var inventory_menu = Inventory_Menu.instance()
	inventory_menu.connect("close_inventory", self, "back_to_idle")
	player.add_child(inventory_menu)
	
func back_to_idle():
	state_machine.transition_to("Idle")
