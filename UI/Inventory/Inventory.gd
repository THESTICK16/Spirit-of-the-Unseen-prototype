class_name Inventory
extends TitleScreenMenu

#signal close_inventory

onready var equipment = Equipment
onready var item_slots = $CenterContainer/ItemSlots
onready var center_container = $CenterContainer

## The PackedScene of the InventoryItem scene
onready var inventory_item = preload("res://UI/Inventory/InventoryItem.tscn")
## A list containing the inventory items in the order they are displayed
var items #onready var items = item_slots.get_children()
## The item slot that is currently selected
var currently_selected_item : InventoryItem setget set_currently_selected_item
## The width (number of x axis item slots) of the inventory
var width #onready var width = item_slots.columns
## The height (number if y axis item slots) of the inventory
var height #onready var height = ceil(float(items.size()) / float(item_slots.columns))

func _ready():
	load_inventory_items()
	items = item_slots.get_children()
#	print(items.size()) #FIXME!!
	item_slots.columns = ceil(sqrt(items.size()))
	width = item_slots.columns
	height = ceil(float(items.size()) / float(item_slots.columns))
	_connect_item_slots()
	set_currently_selected_item(items[0])#self.currently_selected_item = items[0]
	for item in items:
		if item.player_has_item:
			set_currently_selected_item(item) #self.currently_selected_item = item
			break
	
func _input(event):
#func _unhandled_input(_event):
#	var current_index = items.find(currently_selected_item) 
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if input.x != 0 or input.y != 0:
		_change_selected(input)
#	if input.x != 0:
#		if current_index + input.x >= 0 and current_index + input.x < items.size():
#			#TODO Make it so that items that the player does not yet have cannot be selected
#			self.currently_selected_item = items[current_index + input.x]
##TODO put this part of the code in a separate function that takes a vector2
#	else:
#		input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#		if input.y != 0:
#			input.y *= width
#			if current_index + input.y >=0 and current_index + input.y < items.size():
#				#TODO Make it so that items that the player does not yet have cannot be selected
#				self.currently_selected_item = items[current_index + input.y]
	
	if Input.is_action_just_pressed("a"):
		currently_selected_item.equipped('a')
	elif Input.is_action_just_pressed("b"):
		currently_selected_item.equipped('b')
	elif Input.is_action_just_pressed("x"):
		currently_selected_item.equipped('x')
	elif Input.is_action_just_pressed("y"):
		currently_selected_item.equipped('y')
		
#	if Input.is_action_just_pressed("pause"):
#		close_inventory()
#		emit_signal("close_inventory")
	

func set_currently_selected_item(new_item):
	var old_item = currently_selected_item
	currently_selected_item = new_item
	if old_item != null:
		old_item.unselected()
	currently_selected_item.selected()
	
## Changes the currently selected inventory item based on user input
## @param input the vector 2 representation of the user input
func _change_selected(input : Vector2):
	if currently_selected_item == null or not currently_selected_item.player_has_item:
		return
	
#	var current_index = items.find(currently_selected_item)
	var new_item : InventoryItem = currently_selected_item
	
	if input.x != 0:
		if input.x < 0:
			new_item = new_item.left
			while not new_item.player_has_item:
				new_item = new_item.left
				if new_item == currently_selected_item:
					return
		if input.x > 0:
			new_item = new_item.right
			while not new_item.player_has_item:
				new_item = new_item.right
				if new_item == currently_selected_item:
					return
				
	elif input.y != 0:
		if input.y < 0:
			new_item = new_item.up
			while not new_item.player_has_item:
				new_item = new_item.up
				if new_item == currently_selected_item:
					return
		if input.y > 0:
			new_item = new_item.down
			while not new_item.player_has_item:
				new_item = new_item.down
				if new_item == currently_selected_item:
					return
		
	if new_item != currently_selected_item:
		set_currently_selected_item(new_item) #self.currently_selected_item = new_item
		
		
#		if current_index + input.x >= 0 and current_index + input.x < items.size():
#			new_item = items[current_index + input.x]
#			if not new_item.player_has_item:
#					new_item = currently_selected_item
#			if new_item == currently_selected_item:
#				return
#			self.currently_selected_item = new_item #items[current_index + input.x]
#
#	else:
#		input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#		if input.y != 0:
#			input.y *= width
#			if current_index + input.y >=0 and current_index + input.y < items.size():
#				#TODO Make it so that items that the player does not yet have cannot be selected
#				self.currently_selected_item = items[current_index + input.y]
	
## Connects the left, right, above, and below slots of each item in the inventory
func _connect_item_slots():
	if item_slots.get_child_count() % width != 0: # Note that this current system requires that the bottom row be filled entirely, else this will cause an index out of bounds error when trying to connect it to its left slot
		var temp_Inventory_Item = load("res://UI/Inventory/InventoryItem.tscn")
		while item_slots.get_child_count() % width != 0:
			var new_item = temp_Inventory_Item.instance()
			item_slots.add_child(new_item)
		items = item_slots.get_children()
#		print("ERROR: the bottom row of the inventory is not full, cannot properly connect slots")
#		return

	for i in items.size():
		var cur_item : InventoryItem = items[i]
		cur_item.inventory_slot_number = i
		
		if i % width == 0: #The case that the item slot is located at the left edge of the inventory
			#note that this w
			cur_item.left = items[i + (width - 1)]
			cur_item.right = items[i + 1]
		elif i % width == width - 1: #The case that the item slot is located at the right edge of the inventory
			cur_item.left = items[i - 1]
			cur_item.right = items[i - (width - 1)]
		else:
			cur_item.left = items[i - 1]
			cur_item.right = items[i + 1]
			
		if i - width < 0: # The case that the item slot is located at the top of the inventory
			cur_item.up = items[i + (width * (height - 1))]
			cur_item.down = items[i + width]
		elif i + width >= items.size(): # The case that the item slot is located at the top of the inventory
			cur_item.up = items[i - width]
			cur_item.down = items[i - (width * (height - 1))]
		else:
			cur_item.up = items[i - width]
			cur_item.down = items[i + width]
		
#	for cur_item in items:
#		print("Number: " + str(cur_item.inventory_slot_number) + ", up: " + str(cur_item.up.inventory_slot_number) + ", down: " + str(cur_item.down.inventory_slot_number) + ", left: " + str(cur_item.left.inventory_slot_number) + ", right: " + str(cur_item.right.inventory_slot_number))

func hide():
	center_container.hide()

func show():
	center_container.show()
	
#func close_inventory():
#	call_deferred("emit_signal", "close_inventory") #emit_signal("close_inventory")
#	queue_free()
	
func load_inventory_items():
	for item in equipment.all_items:
		if item == "NullItem":
			continue
		var item_slot : InventoryItem = inventory_item.instance()
		item_slot.item_name = equipment.get_item_field(item, Item.NAME)
		item_slots.add_child(item_slot)
