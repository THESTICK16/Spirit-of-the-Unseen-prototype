extends Resource

## A wrapper for a single "item" that contains:
## The name of the item 
## The filepath to the item's scene file (.tscn)
## The item's PackedScene
## The texture for the item's icon to be used in UI elements
## A boolean describing wether the player has acquired the item in the game thus far
class_name Item

## The name of the item (should match the file name of the packed scene minus the ".tscn"
export (String) var name 
## The file path of the item scene (path the .tscn file)
export (String) var filepath 
## The packed scene of the item in question (.tscn)
export (PackedScene) var scene 
## The texture of the icon to be used for the item in inventory and equipment displays (not the sprite for the item)
export (Texture) var texture 
## True if the player has acquired the item in the game, false if they have not
export (bool) var player_has_item := false setget set_player_has_item
## The message that will be displayed when the player first obtains this item
export (String) var acquisition_message
## A dictionary that contains the values for all of the fields for the Item
## The key is the name of the field
## Loaded by the "load_dictionary" function
##Due to the nature of resources the load_dictionary function must be called from the object that loads the Item
var item_fields 

## The below consts are the field names that can be entered into the get_item_field function
## No calls should be made to get_item_field without using one of these as a paramater
const NAME := "name"
const FILEPATH := "filepath"
const SCENE := "scene"
const TEXTURE := "texture"
const PLAYER_HAS_ITEM := "player_has_item"
const ACQUISITION_MESSAGE := "acquisition_message"
const FIELD_NAMES = [NAME, FILEPATH, SCENE, TEXTURE, PLAYER_HAS_ITEM, ACQUISITION_MESSAGE]
const NULLITEM := "NullItem"

signal item_acqusition_changed(has_item)

## Equivalent to the "ready" function. Must bve called externally by the object loading the Item
func initialize_item():
	pass
	
## Loads the item_fields dictionary to have each field value mapped to the field's name as the key
func load_dictionary():
	item_fields = {"name" : self.name, "filepath" : self.filepath, "scene" : self.scene, "texture" : self.texture, "player_has_item" : self.player_has_item, ACQUISITION_MESSAGE : self.acquisition_message}

## Returns the dicitionary value of the field mapped to 'field_name'
## @param field_name the name of the value to be returned (SHOULD ONLY BE PASSED ONE OF THE CONSTANTS FOR THE FIELD NAMES!)
func get_item_field(field_name : String):
	if not has_field(field_name):
#	if not FIELD_NAMES.has(field_name):
		print("This field does not exist")
		return null
		
	return item_fields.get(field_name)

func has_field(field_name) -> bool:
	if FIELD_NAMES.has(field_name):
		return true
	return false

## Sets 'player_has_item' to true
## Represents the player acquiring this item, and should update the player's ability to use the item accordingly (uodate inventory, etc.)
func set_player_has_item(has_item : bool):
	player_has_item = has_item
	emit_signal("item_acqusition_changed", player_has_item)
