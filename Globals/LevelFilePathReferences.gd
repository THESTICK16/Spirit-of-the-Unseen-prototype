extends Node

## A dictionary containg the levels' names as the key referencing their filepaths 
const levels := {}

const directory_path := "res://Levels/"
const DEMO_DUNGEON = preload("res://Levels/DemoDungeon.tscn")

func _ready():
#	load_level_paths()
	pass
	
func load_level_paths():
	
	
#	var canvas_layer = CanvasLayer.new() #FIXME!!!
#	canvas_layer.layer = 50 #FIXME!!!
#	var label = Label.new() #FIXME!!!
#	canvas_layer.add_child(label) #FIXME!!!
	
	
	
	var levels_dict : Dictionary = {}
	var levels_directory = Directory.new()
	if levels_directory.open(directory_path) == OK:
		levels_directory.list_dir_begin()
		
#		var all_levels : String #FIXME!!!
		
		var file_name : String = levels_directory.get_next()
		while file_name != "":
			
			
#			all_levels += file_name + "\n" #FIXME!!!
			
			
#			print(file_name.fil)
			file_name = levels_directory.get_next()
			
			
			
#		label.text = all_levels #FIXME!!!
#		get_tree().root.call_deferred("add_child", canvas_layer) # .add_child(canvas_layer) #FIXME!!!
