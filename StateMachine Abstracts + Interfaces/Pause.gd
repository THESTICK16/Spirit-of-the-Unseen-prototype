extends PlayerState

onready var Inventory_Menu = preload("res://UI/Inventory/Inventory.tscn")
onready var Pause_Screen = preload("res://UI/Menus/PauseMenu/PauseScreen.tscn")

## The instance of PauseScreen that is currently displayed while paused. Should be null if not paused
var pause_screen

## Virtual function. Receives events from the `_unhandled_input()` callback.
##@param _event the InputEvent to be handled
##@override
func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
#		state_machine.transition_to("Idle")
		PauseController.unpause()
		back_to_idle()
	
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
	pause_screen = Pause_Screen.instance()
	pause_screen.connect("menu_closed", self, "back_to_idle")
	PauseController.pause_with_pause_screen(pause_screen)


## Virtual function. Called by the state machine before changing the active state. Use this function
## to clean up the state.
##@override
func exit() -> void:
	PauseController.unpause()
	
func pause_menu():
	self.pause_screen = Pause_Screen.instance()
	player.add_child(pause_screen)
	
	
func inventory():
	var inventory_menu = Inventory_Menu.instance()
	inventory_menu.connect("close_inventory", self, "back_to_idle")
	player.add_child(inventory_menu)
	
func back_to_idle():
	state_machine.transition_to("Idle")
