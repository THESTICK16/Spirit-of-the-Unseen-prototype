extends KinematicBody2D

## A list containing all the item refills that this container could hold, stored as PackedScenes
## This should be saved and loaded as more items can be added
export (Array, PackedScene) var possible_item_refills := []

onready var hurtbox = $HurtBox

func _ready():
	randomize()
	if hurtbox != null:
		hurtbox.connect("area_entered", self, "open")

## Adds an item to the list of items this scene can spawn
## Should be called when the player acquires a new refillable resource
func add(new_refill : PackedScene):
	if not possible_item_refills.has(new_refill):
		possible_item_refills.append(new_refill) 
		
func open(_area):
	var refill_selector = randi() % possible_item_refills.size()
	
	if possible_item_refills.size() == 1 or randi() % 10 > 0: #refill_selector != possible_item_refills.size():
		var new_refill = possible_item_refills[refill_selector].instance()
		new_refill.global_position = global_position
		get_tree().root.add_child(new_refill)
		
	queue_free()
