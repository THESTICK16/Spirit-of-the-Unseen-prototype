extends Item
class_name SpiritItem

## The amount of spirit energy that this item consumes upon use
export (int) var spirit_cost

## The below consts are the field names that can be entered into the get_item_field function
## No calls should be made to get_item_field without using one of these as a paramater
const SPIRIT_COST = "spirit_cost"
const SPIRIT_ITEM_FIELD_NAMES = [SPIRIT_COST]

func load_dictionary():
	item_fields = {"name" : self.name, "filepath" : self.filepath, "scene" : self.scene, "texture" : self.texture, "player_has_item" : self.player_has_item, SPIRIT_COST : self.spirit_cost}


func has_field(field_name) -> bool:
	if FIELD_NAMES.has(field_name) or SPIRIT_ITEM_FIELD_NAMES.has(field_name):
		return true
	return false
