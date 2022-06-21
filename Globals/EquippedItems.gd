extends Node

onready var equipment = Equipment

## A dictionary of the player's currently equipped items' Item resources
## The dictionary key is the button char that the item is equipped to (see equippable_buttons
onready var equipped_items = {'a' : equipment.NULLITEM, 'b' : equipment.NULLITEM, 'x' : equipment.NULLITEM, 'y' : equipment.NULLITEM}
#Once saving is implemented, make these load the player's equipped items and make sure to emit the button_equipped_changed signal!

## The buttons to which an item can be equipped
const equippable_buttons = ['a', 'b', 'x', 'y']

## Emitted if any of the equipped items are changed
signal equipped_items_changed

##Emitted for a specific button change
signal button_equipped_changed(button, new_item)

func _ready():
	call_deferred("load_initial_inventory") #FIXME! Delete this when implementing a "load save data" function. This is for saving time while testing only!

func equip_item(item: Item, button: String):
	if (item == null) or (not ControllerButtons.is_equippable_button(button)):
		return
	if equipped_items.get(button) == item:
		return
	
	var removed_item = equipped_items.get(button)
	for i in equippable_buttons:
		if item == equipped_items.get(i):
			equipped_items[i] = removed_item
			emit_signal("button_equipped_changed", i, removed_item)

	equipped_items[button] = item
	
	emit_signal("equipped_items_changed")
	emit_signal("button_equipped_changed", button, item)
	
func get_equipped_item_resource(button: String) -> Item:
	if equipped_items.get(button) == null:
		print("This item is not equipped or does not exist")
		return equipment.get_item_resource(Item.NULLITEM)
	if not ControllerButtons.is_equippable_button(button):
#	if not equippable_buttons.has(button):
#		print("This is not an equippable button")
		return equipment.get_item_resource(Item.NULLITEM)
	
#	var this_item : Item = equipped_items.get(button)
#	var item_name = this_item.get_item_field(Item.NAME)
#	return equipment.get_item_resource(item_name)
	return equipped_items.get(button)

#	var testingpurposesonlyfixme = equipped_items.get(button)
#	return equipment.get_item_resource(testingpurposesonlyfixme.get_item_field(Item.NAME))
	
func get_equipped_item_field(button : String, field_name : String):
#	if not equippable_buttons.has(button):
#		print("This is not an equippable button")
	if not ControllerButtons.is_equippable_button(button):
		return null #equipment.get_item_resource(Item.NULLITEM)
	var item : Item = equipped_items.get(button)
#	item = equipment.get_item_resource(item.get_item_field(Item.NAME))
	if item == null:
		print("This item is not equipped or does not exist")
		return equipment.get_item_resource(Item.NULLITEM)
	
	return item.get_item_field(field_name)
	
## Finds the button to which the given item is equipped
## @param item The item to check for. This is the PackedScene of the item, not the resource, and therefore must be compared to Item.SCENE
func get_equipped_button(item : Item):
	for i in equipped_items:
		if item == equipped_items.get(i): #.get_item_field(Item.SCENE):
			return i
	print("This item is not equipped")
	return null
	
## Returns a copy a copy of the dictionary holding the equipped_items
func get_equipped_items_copy() -> Dictionary:
	return equipped_items.duplicate()
	
func load_initial_inventory(): #This function is meant for testing purposes only and is used to save me time. Do this from the "load" method that will be implemented later
	equip_item(equipment.get_item_resource("Boomerang"), ControllerButtons.A)
#	equip_item(equipment.get_item_resource("Sword"), ControllerButtons.B)
	equip_item(equipment.get_item_resource("Arrow"), ControllerButtons.X)
	equip_item(equipment.get_item_resource("SpiritBomb"), ControllerButtons.Y)
	
#func is_equippable_button(button : String) -> bool:
#	if not equippable_buttons.has(button):
#		print(button + " is not an equippable button")
#		return false
#
#	return true
	
	
#	var item_at_button = equipped_items.get(button)
#
#	if equippable_buttons == null:
#		return equipment.get_item_resource("NullItem")
#
#	return item_at_button
