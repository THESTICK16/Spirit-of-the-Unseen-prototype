extends Control

onready var control_options = $ControlOptions
onready var save_button = $SaveButton
onready var keybind_settings = $KeybindSettings

onready var keybinds = keybind_settings.keybinds.duplicate()

const keybind_button_script_path := preload("res://UI/TitleScreen/Options/KeybindButton.gd")

## A dictionary that is to contain a list of all the buttons in the control options menu
var buttons = {}

func _ready():
	save_button.connect("pressed", self, "save_keybinds")
	setup_control_options()
	
	
func setup_control_options():
	for key in keybinds.keys():
		var hbox : HBoxContainer = HBoxContainer.new()
		var label: Label = Label.new()
		var button : Button = Button.new()
		hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		
		
		
		var control_label : String = str(key)
#		if control_label.begins_with("ui_"):
		control_label = control_label.trim_prefix("ui_")
		control_label = control_label.to_upper()
		label.text = control_label
		
		var button_value = keybinds.get(key)
		button.text = OS.get_scancode_string(button_value)
		
		button.set_script(keybind_button_script_path)
		button.key = key
		button.value = button_value
#		button.menu = self #Use the signal instead, this is just a remnant from the tutorial
		button.connect("keybinding_changed", self, "update_keybinds")
		button.toggle_mode = true #Make this load a popup menu instead
		
		buttons[key] = button
		
		hbox.add_child(label)
		hbox.add_child(button)
		control_options.add_child(hbox)

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
