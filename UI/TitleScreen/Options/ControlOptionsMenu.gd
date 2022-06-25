extends Control

onready var control_options = $ControlOptions
onready var save_button = $ControlOptions/SaveButton
onready var keybind_settings = $KeybindSettings
onready var keybind_option = preload("res://UI/TitleScreen/Options/KeybindOption.tscn")

onready var keybinds = keybind_settings.keybinds.duplicate()

const keybind_button_script_path := preload("res://UI/TitleScreen/Options/KeybindButton.gd")

## A dictionary that is to contain a list of all the buttons in the control options menu
var buttons = {}

func _ready():
	save_button.connect("pressed", self, "save_keybinds")
	setup_control_options()
	save_button.grab_focus()
	
	
func setup_control_options():
	for key in keybinds.keys():
		var new_keybind_option = keybind_option.instance()
		var input_label = new_keybind_option.get_node("InputLabel")
		var keybind_button = new_keybind_option.get_node("KeybindButton")
		assert(input_label != null)
		assert(keybind_button != null)
		
		var input_label_text : String = str(key)
#		if control_label.begins_with("ui_"):
		input_label_text = input_label_text.trim_prefix("ui_")
		input_label_text = input_label_text.to_upper()
		input_label.text = input_label_text
		
		var button_value = keybinds.get(key)
		keybind_button.text = OS.get_scancode_string(button_value)
		
#		button.set_script(keybind_button_script_path)
		keybind_button.key = key
		keybind_button.value = button_value
#		button.menu = self #Use the signal instead, this is just a remnant from the tutorial
		keybind_button.connect("keybinding_changed", self, "update_keybinds")
		keybind_button.toggle_mode = true #Make this load a popup menu instead
		
		buttons[key] = keybind_button
		
		control_options.add_child(new_keybind_option)

func update_keybinds(key, new_value):
	var old_value = keybinds.get(key)
	keybinds[key] = new_value
	
	for current_key in keybinds.keys():
		if current_key != key and new_value != null and keybinds.get(current_key) == new_value:
			keybinds[current_key] = old_value
			var current_button = buttons.get(current_key)
			current_button.change_keybind_button(old_value)
#			current_button.value = old_value
#			buttons.get(current_key).value = old_value
#			buttons.get(current_key).text = "Unassigned"

func save_keybinds():
	keybind_settings.keybinds = keybinds.duplicate()
#	Keybinds.set_keybinds()
