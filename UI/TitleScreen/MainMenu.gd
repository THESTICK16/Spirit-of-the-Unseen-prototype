extends TitleScreenMenu

onready var new_game_button = $VBoxContainer/HBoxContainer/Buttons/NewGameMenuButton
onready var top_button = $VBoxContainer/HBoxContainer/Buttons.get_children()[0]
onready var buttons = $VBoxContainer/HBoxContainer/Buttons.get_children()

func _ready():
#	new_game_button.grab_focus()
	top_button.grab_focus()
#	print(top_button.name) #FIXME
	for button in buttons:
		button.connect("pressed", self, "button_pressed", [button.path_to_scene_to_load])
#		button.connect("pressed", self, "button_been_pressed_yo", [button.path_to_scene_to_load])

func button_pressed(next_scene_path : String):
	if next_scene_path.ends_with("tscn"):
#		get_tree().change_scene(next_scene_path) #FIXME implement the pseudo code below with a transition scene
		TransitionController.change_to_new_scene(next_scene_path)
	else:
		if has_method("set_new_displayed_menu"):
			set_new_displayed_menu(next_scene_path)
#	var next_scene = load(next_scene_path)
# while loading this scene, play the transition effect
# Better yet, load the new scene in the transition scene
