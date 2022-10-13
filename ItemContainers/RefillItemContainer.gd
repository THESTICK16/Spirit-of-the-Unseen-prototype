extends KinematicBody2D

## A list containing all the item refills that this container could hold, stored as PackedScenes
## This should be saved and loaded as more items can be added
export (Array, PackedScene) var possible_item_refills := []

export var specific_refill : PackedScene setget set_specific_refill

export var breaking_sound : AudioStream

#onready var hurtbox = $HurtBox

func _ready():
	randomize()
#	if hurtbox != null:
#		hurtbox.connect("area_entered", self, "open")

## Adds an item to the list of items this scene can spawn
## Should be called when the player acquires a new refillable resource
func add(new_refill : PackedScene):
	if not possible_item_refills.has(new_refill):
		possible_item_refills.append(new_refill) 
		
func set_specific_refill(new_specific_refill: PackedScene):
	specific_refill = new_specific_refill
		
func open(_area):
	if breaking_sound != null:
		SFXController.play_sfx(breaking_sound, false)
	
	if specific_refill == null and possible_item_refills.size() <= 0:
		queue_free()
		return
		
	var new_refill
	if specific_refill != null:
		new_refill = specific_refill.instance()
		
	
	
	if new_refill == null and (possible_item_refills.size() == 1 or randi() % 10 > 0):
		var refill_selector = randi() % possible_item_refills.size()
		new_refill = possible_item_refills[refill_selector].instance()
		
	if new_refill != null:
		new_refill.global_position = global_position
#		get_tree().current_scene.call_deferred("add_child", new_refill) #.add_child(new_refill)
		get_parent().call_deferred("add_child", new_refill) # Add to parent because parent will likely be a YSort
		
	queue_free()
	
func broken():
	open(null)
