extends CanvasLayer

onready var new_game_button = $MainMenu/VBoxContainer/HBoxContainer/Buttons/NewGameMenuButton
onready var buttons = $MainMenu/VBoxContainer/HBoxContainer/Buttons.get_children()

func _ready():
	new_game_button.grab_focus()
	for button in buttons:
		button.connect("pressed", self, "button_pressed", [button.path_to_scene_to_load])
	
func button_pressed(next_scene_path : String):
	get_tree().change_scene(next_scene_path) #FIXME implement the pseudo code below with a transition scene
#	var next_scene = load(next_scene_path)
# while loading this scene, play the transition effect
# Better yet, load the new scene in the transition scene
	
