extends Node
## Controlles the logic to pause the game
## This allows pause to be controlled from a single script instead of copying the logic everywhere

signal paused

signal unpaused

func pause():
	emit_signal("paused")
	get_tree().paused = true
	
func unpause():
	get_tree().paused = false
	emit_signal("unpaused")
	
func is_paused()-> bool:
	if get_tree().paused:
		return true
	else: 
		return false
