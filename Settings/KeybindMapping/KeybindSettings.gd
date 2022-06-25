## Remaps the InputMap based on a customization menu and a ini file
## From tutorial, Godot - How to make a Keybinds Settings Menu, found at: https://www.youtube.com/watch?v=I_Kzb-d-SvM&t=535s
extends Node

var keybinds_filepath =  "res://Settings/KeybindMapping/Keybinds.ini" #/Users/ryorke16/Documents/Godot Projects/Reproduceables/KeybindMapping/test_keybinds.ini"
var configfile

var keybinds = {} setget set_keybinds

func _ready():
	load_config_file()

func load_config_file():
	configfile = ConfigFile.new()
	if configfile.load(keybinds_filepath) == OK:
		for key in configfile.get_section_keys("keybinds"):
			var key_value = configfile.get_value("keybinds", key)
			
#			keybinds[key] = key_value
			if str(key_value) != "":
				keybinds[key] = key_value
			else:
				keybinds[key] = null
			
#			print(key, " : ", key_value, " : ", OS.get_scancode_string(key_value)) #FIXME
	else:
		print("CONFIG FILE NOT FOUND")
		
	set_keybinds(keybinds)
		
func set_keybinds(new_keybinds):
	if new_keybinds == null:
		return
		
	keybinds = new_keybinds
	
	for key in keybinds.keys():
		var value = keybinds.get(key) #The value of the input to which this key maps
		
		var actionlist = InputMap.get_action_list(key)
		if not actionlist.empty():
			InputMap.action_erase_event(key, actionlist[0]) #BE CAREFUL HERE!!! DON'T ERASE ACTIONS YOU DON'T WANT ERASED SUCH AS CONTROLLER INPUTS!!!
			
			if value != null:
				var new_key = InputEventKey.new()
				new_key.set_scancode(value)
				InputMap.action_add_event(key, new_key)
			
	save_keybinds()
	
	print("KEYBINDING CHANGED") #FIXME
			
func save_keybinds():
	for key in keybinds.keys():
		var key_value = keybinds.get(key)
		if key_value == null:
			key_value = ""
		configfile.set_value("keybinds", key, key_value)
	configfile.save(keybinds_filepath)
