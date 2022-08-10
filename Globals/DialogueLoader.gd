extends Node

onready var dialogue_box = preload("res://UI/Dialogue+/DialogueBox.tscn")
#onready var dialogue_box = preload("res://UI/Dialogue+/NewDialogueBox.tscn") #preload("res://UI/Dialogue+/DialogueBox.tscn")

## The dialogue to display if there is an error in loading the proper dialogue
var error_response := {0: "Whoops looks like the developer forgot to write any dialogue for me :("}

## Creates a dialogue box and passes it the dialogue found from source
## @param source The source of the dialogue to load. Must be either a JSON file or a Dictionary
## @param start_key If the JSON file contains several dictionaries, the start_key is used to determine which dictionary to pull the dialogue from
func create_dialogue_box(source, start_key = null):
	var dialogue : Dictionary
#	if not start_key is int or start_key != 0:
	if start_key != null:
		if source is String and source.ends_with("json"):
			var bigger_dialogue_dictionary : Dictionary = _get_dialogue_from_json(source) # The dialogue of the entire JSON file, not just the specific dialogue that will be retrieved with start_key
			dialogue = bigger_dialogue_dictionary.get(start_key)
		elif source is Dictionary:
			dialogue = source.get(start_key)
	else:
		dialogue = _get_dialogue_from_json(source)
			
	var new_box = dialogue_box.instance()
#	new_box.dialogue_path = source
	new_box.call_deferred("new_dialogue", dialogue)
	new_box.connect("dialogue_finished", PauseController, "unpause")
	get_tree().current_scene.add_child(new_box)
	PauseController.pause()

## Gets the contents of a JSON file loaded from path
## @param path : The path to the JSON file that will be loaded and parsed for the dialogue 
func _get_dialogue_from_json(path : String) -> Dictionary:
	if not path.ends_with("json"):
		push_error("Sorry, the filepath that you entered is not for a file of type JSON")
		return error_response
	var file := File.new()
	if not file.file_exists(path):
		return error_response
	else:
		file.open(path, File.READ)
		var json := file.get_as_text()

		var output = parse_json(json)
		if typeof(output) == TYPE_DICTIONARY:
			return output
		else:
			return error_response 
