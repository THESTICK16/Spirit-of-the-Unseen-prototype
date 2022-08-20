class_name InventoryItem
extends Panel

onready var equipment = Equipment
onready var equipped_items = EquippedItems
onready var texture_rect = $TextureRect
onready var default_background = $DefaultBackgroundColorRect
onready var selected_background = $SelectedBackgroundColorRect
onready var reference_rect = $ReferenceRect
onready var stock_label = $StockLabel
onready var visibility_notifier = $VisibilityNotifier2D
onready var tween = $Tween

### Emitted when the player gets or loses the item
#signal item_acquisition_changed(has_item)
### Emitted when the player acquires the item
#signal item_acquired
### Emitted when the player loses the item
#signal item_lost
##Emitted when an item is selected to be equipped to a button
signal item_equipped(item, button)

## The name of the item (as is in it's file name and resource field 'name'
## This is the only field that should be assigned by an external function call
var item_name : String

## The scene path of the item that this inventory slot representes
var item : PackedScene
## True if the player has acquired this item in the game, else false
var player_has_item : bool #:= false setget set_has_item
## The sprite to display for the item
var item_icon : Texture
## If true, the item is a ConsumableItem, else false
var is_consumable_item := false
## The current inventory of the item
var item_stock : int
## The maximum storgae of the item
var item_maximum_storage : int

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

const hud_button_locations = {'a': Vector2(1004, 64), 'b': Vector2(960, 108), 'x': Vector2(960, 20), 'y': Vector2(916, 64)}

func _ready():
	if item_name != null and item_name != "":
		load_inventory_item_data()
		
	if texture_rect != null:
#		if texture_rect.texture == null and item_icon != null:
		texture_rect.texture = item_icon
		
		if player_has_item:
			texture_rect.show()
		else:
			texture_rect.hide()
	
	if is_consumable_item and stock_label != null:
		if player_has_item:
			stock_label.show()
		else: stock_label.hide()
		stock_label.text = str(item_stock) + "/" + str(item_maximum_storage)
		
	connect("item_equipped", equipped_items, "equip_item")
	
func load_inventory_item_data():
	item = equipment.get_item_field(item_name, Item.SCENE)
	item_icon = equipment.get_item_field(item_name, Item.TEXTURE)
	player_has_item = equipment.get_item_field(item_name, Item.PLAYER_HAS_ITEM)
	if equipment.get_item_resource(item_name) is ConsumableItem:
		is_consumable_item = true
		item_stock = equipment.get_item_field(item_name, ConsumableItem.CURRENT_STOCK)
		item_maximum_storage = equipment.get_item_field(item_name, ConsumableItem.MAX_STORAGE)
	

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
#	if button != 'a' and button != 'b' and button != 'x' and button != 'y':
	if not equipped_items.equippable_buttons.has(button) or not visibility_notifier.is_on_screen() or not player_has_item:
		return
#	if not player_has_item:
#		return
	
	var new_equipped_item: Item = equipment.get_item_resource(item_name)
#	emit_signal("item_equipped", item, button) #This returns he PackedScene of the item, which cannot be used to update icons, etc.
	animate_to_hud(hud_button_locations.get(button))
	if tween.is_active():
		yield(tween, "tween_completed")
	emit_signal("item_equipped", new_equipped_item, button)
#	print(item) #FIXME

func animate_to_hud(destination : Vector2):
	var duplicate_texture = Sprite.new() #texture_rect.duplicate()
	duplicate_texture.global_position = texture_rect.rect_global_position + (texture_rect.rect_size / 2)
	duplicate_texture.texture = texture_rect.texture
#	get_tree().current_scene.add_child(duplicate_texture)
	add_child(duplicate_texture)
	tween.interpolate_property(duplicate_texture, "global_position", duplicate_texture.position, destination, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(duplicate_texture, "scale", Vector2(3,3), Vector2(1,1), 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	duplicate_texture.queue_free()
	
		
## Called when the var player_has_item 's value is changed
#func set_has_item(has_item : bool):
#	player_has_item = has_item
#	if player_has_item:
#		emit_signal("item_acquired")
#	elif not player_has_item:
#		emit_signal("item_lost")
#	emit_signal("item_acquisition_changed", has_item)
