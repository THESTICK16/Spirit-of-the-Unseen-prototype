class_name Interactables
extends Node

## Standard dialogue with just a text box (no name)
const DIALOGUE = "dialogue"
## Dialogue for a named character who's name should be displayed in the text box
const NAME_DIALOGUE = "name_dialogue"
## Objects that can be picked up
const LIFTABLE = "liftable"
## Objects that can be pushed or pulled
const PUSHABLE = "pushable"
## Objects that can be opened
const OPENABLE = "openable"

## Returns the text that the A button label on the HUD should be set to 
static func get_interactable_label_text(interactable_type: String) -> String:
	match interactable_type:
		DIALOGUE:
			return "Talk"
		NAME_DIALOGUE:
			return "Talk"
		LIFTABLE:
			return "Lift"
		PUSHABLE:
			return "Push"
		OPENABLE:
			return "Open"
		
	return ""
