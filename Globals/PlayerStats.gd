extends Node

## Emitted whenever 'health' changes with the new value
signal health_changed(new_hp)
##Emitted when 'spirit energy' changes with the new value
signal spirit_energy_changed(new_se)
## Emitted when the number of dungeon keys changes
signal dungeon_keys_changed(new_key_count)

## The current instance of the player in the current scene. 
## To be set by the player's _ready function
var player : KinematicBody2D
## The maximum health value the player can have, can be added to with upgrades
var max_health := 100
## The player's current health
onready var health := max_health setget set_health
## The maximum amount of spirit energy a player can have
var max_spirit_energy := 100
## The player's current spirit energy
onready var spirit_energy = max_spirit_energy setget set_spirit_energy
## The umber of keys the player has acquired
## In the final game, make this a dictionary where each dungeon has its own key count so they can't be transferred
var dungeon_keys := 0 setget set_dungeon_keys
## The maximum the player can move during normal movement
const MAX_SPEED := 250
## The rate at which the player will move toward their maximum speed using the move_toward function
## To be multiplied by delta, hence the high value
export var acceleration := 1500
## The rate at which the player will move toward a velocity of zero using the move_toward function when no movement input is detected
## To be multiplied by delta, hence the high value
export var friction := 1250
## If true, objects that have a stunning effect will cause the player to be stunned
export var stunnable := true
## If true, objects with a damaging effect will damage the player
export var damageable := true 

##------------------------------------------------
#	 #Inventory
#var Boomerang = preload("res://Weapons/Boomerang.tscn")
#var Arrow = preload("res://Weapons/Arrow.tscn")
#var Sword  = preload("res://Weapons/Sword.tscn")
#var RotateAttack = preload("res://Weapons/RotateAttack.tscn")
#var SpiritBomb = preload("res://Weapons/SpiritBomb.tscn")
#onready var inventory = {"Boomerang": Boomerang, "Arrow": Arrow, "Sword": Sword, "RotateAttack": RotateAttack, "SpiritBomb": SpiritBomb}
##------------------------------------------------

##------------------------------------------------
#   #Equipped Items
### The buttons to which an item can be equipped
#const equipable_buttons = ['a', 'b', 'x', 'y']
#onready var equipped_item_a = Boomerang # temporarily set to boomerang, in the end modified through the menu get rid of the onready
#onready var equipped_item_b = Sword # temporarily set to sword, in the end modified through the menu. get rid of the onready
#onready var equipped_item_x = Arrow # temporarily set to arrow, in the end modified through the menu. get rid of the onready
#onready var equipped_item_y = SpiritBomb # temporarily set to RotateAttack, in the end modified through the menu. get rid of the onready
### A dictionary containing the player's currently equipped items, with the key being the button it is equiiped to and the button being the item itself
#var equipped_items = {"a": Boomerang, "b": Sword, "x": Arrow, "y": SpiritBomb} #this may be a better way to handle equipped items
##------------------------------------------------
## If the Eyes of the Spirit are active, set to true, otherwise set to false
var eyes_active := false setget set_eyes_active
## if true, player has acquired the eyes of the Spirit, else false
var player_has_eyes_of_the_spirit := true #fix. set to false for final product

#func equip_item(item, button: String):
#	if button != 'a' and button != 'b' and button != 'x' and button != 'y':
#		return
#	if equipped_items.get(button) == item:
#		return
#
#	if true: #item != null:
#		var removed_item = equipped_items.get(button)
#		for i in equipable_buttons:
#			if item == equipped_items.get(i):
#				equipped_items[i] = removed_item
#		equipped_items[button] = item
#
#	equipped_item_a = equipped_items.get('a')
#	equipped_item_b = equipped_items.get('b')
#	equipped_item_x = equipped_items.get('x')
#	equipped_item_y = equipped_items.get('y')
#
#	emit_signal("equipped_items_changed")
	

func set_health(new_health):
	if (is_instance_valid(player) and not player.is_dead) or not is_instance_valid(player):
		health = new_health
		if health < 0:
			health = 0
		if health > max_health:
			health = max_health
			
		emit_signal("health_changed", health)
		if health <= 0:
			if is_instance_valid(player):
				player.state_machine.transition_to("Dead")
			
func set_spirit_energy(new_spirit_energy):
	if (is_instance_valid(player) and not player.is_dead) or not is_instance_valid(player):
		spirit_energy = new_spirit_energy
		if spirit_energy < 0:
			spirit_energy = 0
		if spirit_energy > max_spirit_energy:
			spirit_energy = max_spirit_energy
			
		emit_signal("spirit_energy_changed", spirit_energy)
	#Add a rechargability function
	#Add more detail for implementation once spirit energy is implemented further
	
func has_spirit_energy() -> bool:
	if spirit_energy <= 0:
		return false
	return true
	
func set_eyes_active(are_active : bool):
	if is_instance_valid(player) and player.is_dead:
		return
	eyes_active = are_active
	if get_tree().has_group("Unseen"):
		get_tree().call_group("Unseen", "set_visible", not eyes_active)
		
func set_dungeon_keys(new_key_count):
	if new_key_count < 0:
		return
	if new_key_count > dungeon_keys:
		DialogueLoader.create_dialogue_box(JSONFilePaths.ITEM_ACQUISITION_TEXT_JSON_FILEPATH, "Key")
	dungeon_keys = new_key_count
	emit_signal("dungeon_keys_changed", dungeon_keys)
#	DialogueLoader.create_dialogue_box(JSONFilePaths.ITEM_ACQUISITION_TEXT_JSON_FILEPATH, "Key")
	
func respawn():
	self.health = max_health
	self.spirit_energy = max_spirit_energy
	self.eyes_active = false
	if is_instance_valid(player):
		player.is_dead = false

#func get_equipped_item(button : String):
#	if button != 'a' and button != 'b' and button != 'x' and button != 'y':
#		return
#	return equipped_items.get(button)

#func _unhandled_input(event):
#	if Input.is_action_just_pressed("toggle_eyes"):
#		activate_eyes()
#
#func activate_eyes():
#	print("EYES")
#	for i in get_tree().root.get_children():
#		if i.has_method("toggle_visibility"):
#			i.toggle_visibility()
