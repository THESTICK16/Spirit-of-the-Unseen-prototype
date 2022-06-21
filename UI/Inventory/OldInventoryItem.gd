#class_name OldInventoryItem
extends Panel

onready var texture_rect = $TextureRect
onready var default_background = $DefaultBackgroundColorRect
onready var selected_background = $SelectedBackgroundColorRect
onready var reference_rect = $ReferenceRect

## Emitted when the player gets or loses the item
signal item_acquisition_changed(has_item)
## Emitted when the player acquires the item
signal item_acquired
## Emitted when the player loses the item
signal item_lost
##Emitted when an item is selected to be equipped to a button
signal item_equipped(item, button)

## The scene path of the item that this inventory slot representes
export (PackedScene) var item
## True if the player has acquired this item in the game, else false
export var player_has_item := false setget set_has_item
## The sprite to display for the item
export (Texture) var item_sprite #: Texture

## The items lot above this itemslot in the inventory. If the top slot, decribes the bottom slot in its column
var up : InventoryItem
## The item slot below this item slot in the inventory. If the bottom slot, decribes the top slot in its column
var down : InventoryItem
## The item slot to the right of this item slot in the inventory. If the furtherst right slot, decribes the furthest left slot in its row
var right : InventoryItem
## The item slot to the left of this item slot in the inventory. If the furtherst left slot, decribes the furthest right slot in its row
var left : InventoryItem

## The number of the index of the inventory list that this item is stored at. top left = 0, bottom right = list size - 1
var inventory_slot_number : int

func _ready():
	if texture_rect != null:
		if texture_rect.texture == null and item_sprite != null:
			texture_rect.texture = item_sprite
		if player_has_item:
			texture_rect.show()
		else:
			texture_rect.hide()
		connect("item_acquired", texture_rect, "show")
		connect("item_lost", texture_rect, "hide")
	connect("item_equipped", PlayerStats, "equip_item")
	

## Called when the item is the currently being hovered over in the menu
## Should change the color, add a border, or otherwise make it clear that the player's cursor is over this item
func selected():
	if not player_has_item:
		return
	reference_rect.show()
	selected_background.show()
	default_background.hide()
	
## Called when the item was previously hovered over but the player moved to a new item
##Should undo everything the 'selected' method does and revert to the original state
func unselected():
	reference_rect.hide()
	default_background.show()
	selected_background.hide()
	
## Called when the player presses a button to equip the item
## Should set the item path 'Item' as the equipped inventory item for the button to which the player equipped it
## @param button a single character containing 'a', 'b', 'x', or 'y' representing the button to which this item should be assigned
func equipped(button : String):
	if button != 'a' and button != 'b' and button != 'x' and button != 'y':
		return
	if not player_has_item:
		return
		
	emit_signal("item_equipped", item, button)
	print(item) #FIXME
	
		
## Called when the var player_has_item 's value is changed
func set_has_item(has_item : bool):
	player_has_item = has_item
	if player_has_item:
		emit_signal("item_acquired")
	elif not player_has_item:
		emit_signal("item_lost")
	emit_signal("item_acquisition_changed", has_item)
