extends KinematicBody2D

onready var sprite = $Sprite
onready var item_sprite = $ItemSprite

## The item that the player will receive by opening the chest
export var contained_item_name : String
## If true, the chest has been opened. Else, false
var opened := false setget set_opened

func _ready():
	PauseController.connect("unpaused", item_sprite, "hide")
	set_opened(opened)

## Sets the 'opened' status of the chest and adjusts the sprite frame accordingly
func set_opened(is_opened : bool):
	opened = is_opened
	if opened:
		sprite.frame = 1
	elif not opened:
		sprite.frame = 0
		
func show_item_sprite():
	item_sprite.texture = Equipment.get_item_field(contained_item_name, Item.TEXTURE)
	item_sprite.show()

## @interface
## ALL INTERACTABLE SCENES MUST CONTAIN THIS METHOD!
## Returns the type of interaction that interacting with this object should have
## The return value should be a string of one of the player's states (maybe not, we'll see)
## Return type should be a constant from 'Interactables'
func get_interactable_type() -> String:
	return Interactables.OPENABLE

## @interface
## ALL INTERACTABLE SCENES MUST CONTAIN THIS METHOD!
## Contains the logic for what happens when the player interacts with this object
func interact():
	if opened:
		return
	var contained_item = Equipment.get_item_resource(contained_item_name)
	if contained_item is Item:
		contained_item.set_player_has_item(true)
	self.opened = true
	show_item_sprite()
	DialogueLoader.create_dialogue_box(JSONFilePaths.ITEM_ACQUISITION_TEXT_JSON_FILEPATH, contained_item_name)
