extends Node
## Contains the filepaths to dialogue JSON files for easy access from anywhere in the script
class_name JSONFilePaths

#When shipping the game, I will have to create new file paths for saves and for storing existing JSONS. These will not work since other players' file directories will look different
#This link may be helpful: https://godotengine.org/qa/40959/json-not-saving-after-exporting-the-game

const ITEM_ACQUISITION_TEXT_JSON_FILEPATH = "/Users/ryorke16/Documents/Godot Projects/Spirit of the Unseen Prototype/Dialogue JSONs/Item Acquisition JSON Sheet.json"

const MISCELLANEOUS_MESSAGES_JSON_FILEPATH = "/Users/ryorke16/Documents/Godot Projects/Spirit of the Unseen Prototype/Dialogue JSONs/MiscellaneousMessages.json"
