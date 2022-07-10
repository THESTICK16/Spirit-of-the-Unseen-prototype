extends Node
## Controlles the logic to pause the game
## This allows pause to be controlled from a single script instead of copying the logic everywhere

signal paused

signal unpaused

onready var Pause_Screen = preload("res://UI/Menus/PauseMenu/PauseScreen.tscn")

func _ready(): 
	TransitionController.connect("scene_changed", self, "unpause")

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
		
func pause_with_pause_screen(pause_screen):
	print(pause_screen) #FIXME
	var new_pause_screen
	if pause_screen is String and pause_screen.ends_with(".tscn"):
		new_pause_screen = load(pause_screen).instance()
	elif pause_screen is PackedScene:
		new_pause_screen = pause_screen.instance()
	elif pause_screen is Node:
		new_pause_screen = pause_screen
#	connect("unpaused", new_pause_screen, "close_menu")
#	get_tree().root.add_child(new_pause_screen)
	get_tree().current_scene.add_child(new_pause_screen)
	pause()
