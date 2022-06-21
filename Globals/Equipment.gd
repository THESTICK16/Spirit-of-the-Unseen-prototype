extends Node

## A dictionary containing all the equippable items in the game
## key is item name, value is item_resource
onready var all_items : Dictionary = _load_items()
## The path to the directory containing the item resources
const items_file_path := "res://Items/"

const NULLITEM = preload("res://Items/NullItem.tres")


## Parses the directory and returns a dictionary containing every 'Item' resource in that directory
## Dictionary keys are the item name in string format (as written in the file name and the 'name' field of the Item resource
## @param the optional filepath to the directory. The default is to the "res://Items/" directory
func _load_items(directory_path := items_file_path) -> Dictionary:
	var items_dict : Dictionary = {}
	var items_directory = Directory.new()
	if items_directory.open(directory_path) == OK:
		items_directory.list_dir_begin()
		
		var file_name : String = items_directory.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var item_resource : Resource = load(items_file_path + file_name)
				if item_resource is Item:
					item_resource.load_dictionary()
					items_dict[item_resource.name] = item_resource
			file_name = items_directory.get_next()
	else:
		print("The Directory " + items_file_path + " could not be found :(")
		
	return items_dict

## Returns the entire item resource
## @param item_name the name of the item as it appears in the file directory and the resource's 'name' field
func get_item_resource(item_name : String) -> Item:
	var item : Item = all_items.get(item_name)
	if item != null:
		return item
	else:
		print("This item does not exist")
		return all_items.get(Item.NULLITEM)
	
### Returns the value of the given field of the item
### @param item_name the name of the item as it appears in the file directory and the resource's 'name' field
## @param field_name the name of the field to return (SHOULD ONLY BE PASSED ONE OF THE CONSTANTS FOR THE FIELD NAMES FOUND IN THE Item CLASS!)
func get_item_field(item_name : String, field_name : String):
	var item : Item = all_items.get(item_name)
	if item != null:
		return item.get(field_name)
	else:
		print("This item does not exist")
		return null

func check_stock(item_name):
	var item : Item = all_items.get(item_name)
	if item is ConsumableItem:
		return item.get_item_field(ConsumableItem.CURRENT_STOCK)
#	else: return -1
