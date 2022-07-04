## Remaps the InputMap based on a customization menu and a ini file
## From tutorial, Godot - How to make a Keybinds Settings Menu, found at: https://www.youtube.com/watch?v=I_Kzb-d-SvM&t=535s
extends Node
## The filepath for the keybinds file that is stored in the project
## To be read from to initialize only. Otherwise read from and write to user_keybinds_filepath
var keybinds_filepath = "res://Settings/KeybindMapping/SOTUKeybinds.ini" # "/Users/ryorke16/Documents/Godot Projects/Spirit of the Unseen Prototype/Settings/KeybindMapping/SOTUKeybinds.ini" #"/Users/ryorke16/Documents/Godot Projects/Spirit of the Unseen Prototype/Settings/KeybindMapping/Keybinds.ini" #"res://Settings/KeybindMapping/Keybinds.ini"
## The filepath for the user's individual settings. To be used in all but the first instance
var user_keybinds_filepath = "user://SOTUKeybinds.ini" #
#var keybinds_filepath =  "/Users/ryorke16/Documents/Godot Projects/Reproduceables/KeybindMapping/test_keybinds.ini"
var configfile

var keybinds = {} setget set_keybinds

## The default keybind settings to be compared against at initialization
## Loaded in the _ready function by accessing the config file
var default_keybinds : Dictionary

const unchanging_key_scancodes = {"space" : 32, "up_arrow" : 16777232, "down_arrow" : 16777234, "left_arrow" : 16777231, "right_arrow" : 16777233}

func _ready():
	load_config_file()

func load_config_file():
#	if not File.new().file_exists(keybinds_filepath):
		
	configfile = ConfigFile.new()
	
	if configfile.load(user_keybinds_filepath) == OK:
		print("User File Exists. Loading User Keybinds...")
		initial_setup() # Set it up so it will load from the users configfile in all instances except the initial instance when the player does not have a configfile and the local one that exists in the project must be loaded
	
	elif configfile.load(keybinds_filepath) == OK:
		print("No User File Exists. Loading Initial Keybinds...")
		initial_setup()
		
#		for key in configfile.get_section_keys("customizable_keybinds"):
#			var key_value = configfile.get_value("customizable_keybinds", key)
#
##			keybinds[key] = key_value
#			if str(key_value) != "":
#				keybinds[key] = key_value
#			else:
#				keybinds[key] = null
		
		
#		default_keybinds = load_keybinds(configfile, "defaults")
##		set_keybinds(default_keybinds.duplicate())
#		keybinds = default_keybinds.duplicate()
#
#		var temp_keybinds = load_keybinds(configfile, "customizable_keybinds")
#		set_keybinds(temp_keybinds)
			
#			print(key, " : ", key_value, " : ", OS.get_scancode_string(key_value)) #FIXME
	else:
		print("CONFIG FILE NOT FOUND")
		
		
#func set_keybinds_old(new_keybinds):
#	if new_keybinds == null:
#		return
#
#	keybinds = new_keybinds
#
#	for key in keybinds.keys():
#		var value = keybinds.get(key) #The value of the input to which this key maps
#
#		var actionlist = InputMap.get_action_list(key)
#		if not actionlist.empty():
##			InputMap.action_erase_event(key, actionlist[0]) #BE CAREFUL HERE!!! DON'T ERASE ACTIONS YOU DON'T WANT ERASED SUCH AS CONTROLLER INPUTS!!!)
##			delete_keybind(key, )
#
#			if value != null:
#				var new_key = InputEventKey.new()
#				new_key.set_scancode(value)
#				InputMap.action_add_event(key, new_key)
#
#	save_keybinds()
#
#	print("KEYBINDING CHANGED") #FIXME
			
func initial_setup():
	default_keybinds = load_keybinds(configfile, "defaults")
	keybinds = default_keybinds.duplicate()
		
	var temp_keybinds = load_keybinds(configfile, "customizable_keybinds")
	set_keybinds(temp_keybinds)

func set_keybinds(new_keybinds : Dictionary):
	if new_keybinds == null:
		return
	
	for key in new_keybinds:
		var new_value = new_keybinds.get(key)
		var old_value = keybinds.get(key)
		
		if new_value != null:
			
			if old_value != new_value and old_value != null:
				var old_event = InputEventKey.new()
				old_event.set_scancode(old_value)
				delete_keybind(key, old_event)
		
		var new_event = InputEventKey.new()
		new_event.set_scancode(new_value)
		add_keybind(key, new_event)
	
	
	keybinds = new_keybinds
	save_keybinds()

	print("KEYBINDING CHANGED") #FIXME

func save_keybinds():
	for key in keybinds.keys():
		var key_value = keybinds.get(key)
		if key_value == null:
			key_value = ""
		configfile.set_value("customizable_keybinds", key, key_value)
#	configfile.save(keybinds_filepath)
	configfile.save(user_keybinds_filepath)
	print("Keybinds saved to " + user_keybinds_filepath)
	
## Adds a new keybind to the InputMap so that pressing that button will trigger the input event
## @param action the name of the action (ex: 'ui_accept') to map the input to
## @param input the InputEvent to map to the action
func add_keybind(action: String, input: InputEvent):
	if InputMap.has_action(action):
		if not InputMap.action_has_event(action, input):
			InputMap.action_add_event(action, input)

## removes a keybind from the InputMap so that pressing that button will no longer trigger the input event
## @param action the name of the action (ex: 'ui_accept') to remove the input from
## @param input the InputEvent to delete from the action
func delete_keybind(action : String, input : InputEvent):
	if InputMap.has_action(action) and InputMap.action_has_event(action, input):
		InputMap.action_erase_event(action, input)
		
func load_keybinds(configfile: ConfigFile, file_section := "customizable_keybinds") -> Dictionary:
	var keybind_dictionary = {}
	if configfile == null or not configfile.has_section(file_section):
		return keybind_dictionary
	
	for key in configfile.get_section_keys(file_section):
		var key_value = configfile.get_value(file_section, key)
		if str(key_value) != "":
			keybind_dictionary[key] = key_value
		else:
			keybind_dictionary[key] = null
			
	return keybind_dictionary
