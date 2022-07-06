extends Area2D

## The resource for the item to refill
export var item_resource : Resource
## The amount by which the refill will refill the thing that it refills
export var refill_amount := 1
## The sound that will play when the item is picked up
export var acquisition_sound : AudioStream

func _ready():
	connect("area_entered", self, "acquire")

func refill_item_stock():
	if item_resource is ConsumableItem:
		item_resource.change_stock(refill_amount)

func acquire(_body):
	refill_item_stock()
	SFXController.play_sfx($AudioStreamPlayer.stream)
	queue_free()
