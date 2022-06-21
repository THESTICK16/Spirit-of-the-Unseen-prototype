extends PlayerState

## The Player state for while in dialogue

## The dialogue box scene
onready var Dialogue_Box = preload("res://UI/Dialogue+/DialogueBox.tscn")

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
#	get_tree().paused = true
#	dialogue_box()
	DialogueLoader.create_dialogue_box("/Users/ryorke16/Documents/Godot Projects/Spirit of the Unseen Prototype/Dialogue JSONs/TestDialogue.json")


## Virtual function. Called by the state machine before changing the active state. Use this function
## to clean up the state.
##@override
func exit() -> void:
	pass
#	get_tree().paused = false

func dialogue_box():
	var dialogue_box = Dialogue_Box.instance()
	dialogue_box.connect("dialogue_finished", self, "back_to_idle")
	get_tree().root.add_child(dialogue_box)
#	player.camera.offset = Vector2.ZERO
#	player.add_child(dialogue_box)
	
func back_to_idle():
	state_machine.transition_to("Idle")
