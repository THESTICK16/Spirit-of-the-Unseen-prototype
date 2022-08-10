extends Area2D

## The filepath for the dialogue that this NPC will load when spoken to
export var dialogue_json_filepath : String
## The optional key to the JSON file if more than one dialogue option is stored there
export var optional_dialogue_key : String

## @interface
## ALL INTERACTABLE SCENES MUST CONTAIN THIS METHOD!
## Returns the type of interaction that interacting with this object should have
## The return value should be a string of one of the player's states (maybe not, we'll see)
## Return type should be a constant from 'Interactables'
func get_interactable_type() -> String:
	return Interactables.DIALOGUE

## @interface
## ALL INTERACTABLE SCENES MUST CONTAIN THIS METHOD!
## Contains the logic for what happens when the player interacts with this object
func interact():
	if dialogue_json_filepath.ends_with("json"):
		DialogueLoader.create_dialogue_box(dialogue_json_filepath, optional_dialogue_key)
	elif dialogue_json_filepath.ends_with("FILEPATH"):
		var filepath = JSONFilePaths.new().get(dialogue_json_filepath) #Gets the path from an instance of JSONFilepaths. 'get()' cannot be called on static scripts
		DialogueLoader.create_dialogue_box(filepath, optional_dialogue_key)
#This could possibly be optimized by loading the dialogue upon loading the scene and storing it in this object until it is needed
