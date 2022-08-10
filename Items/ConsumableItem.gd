extends Item
class_name ConsumableItem

## The maximum number of this item the player can hold
export (int) var max_storage = 10 setget set_max_storage
## The current number of this item the player has
var current_stock : int = max_storage setget set_current_stock

# The below consts are the field names that can be entered into the get_item_field function
## No calls should be made to get_item_field without using one of these as a paramater
const MAX_STORAGE = "max_storage"
const CURRENT_STOCK = "current_stock"
const CONSUMABLE_ITEM_FIELD_NAMES = [MAX_STORAGE, CURRENT_STOCK]

signal stock_changed(new_stock)

## Sets the current_stock to the new_stock value after ensuring it stays within the given paramters
## @param new_stock the new value to set current_stock to
func set_current_stock(new_stock : int):
	if new_stock < 0:
		current_stock = 0
	elif new_stock > max_storage:
		current_stock = max_storage
	else:
		current_stock = new_stock
	
	emit_signal("stock_changed", current_stock)
	
## Sets the max_storage to the new_max value
## @param new_max the new value to set max_storage to
func set_max_storage(new_max):
	max_storage = new_max

func load_dictionary():
	item_fields = {"name" : self.name, "filepath" : self.filepath, "scene" : self.scene, "texture" : self.texture, "player_has_item" : self.player_has_item, MAX_STORAGE : self.max_storage, CURRENT_STOCK : self.current_stock}
	
## Returns true if the given name is the name of a ConsumableItem field
## @param field_name the name to check for in the ConsumableItems field names
func has_field(field_name) -> bool:
	if FIELD_NAMES.has(field_name) or CONSUMABLE_ITEM_FIELD_NAMES.has(field_name):
		return true
	return false
	
## Returns true if current_stock is above 0, else returns false
func can_use() -> bool:
	if current_stock <= 0:
		return false
	return true

## Decreases current_stock by 1
## To be called when the item is used
func decrement_stock():
	self.current_stock -= 1
	
## Changes the current_stock by the given amount
## @param change_by The amount to change the stock by. Should be negative for decreases
func change_stock(change_by : int):
	self.current_stock += change_by
	
## Returns true if current_stock is equal to max_storage, else returns false
func is_full() -> bool:
	if current_stock == max_storage:
		return true
	return false
