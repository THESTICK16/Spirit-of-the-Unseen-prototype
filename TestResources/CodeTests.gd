extends Node

var equipment = Equipment

func _ready():
#	yield()
#	test_get_item_field()
#	print(ceil(sqrt(24)))
#	print(Equipment.get_item_field("Arrow", ConsumableItem.CURRENT_STOCK))
#	DialogueLoader.create_dialogue_box("/Users/ryorke16/Documents/Godot Projects/Spirit of the Unseen Prototype/Dialogue JSONs/TestDialogue.json")
	print(equipment.get_item_field("Arrow", Item.ACQUISITION_MESSAGE))

func test_get_item_field():
	var texture_rect : TextureRect = TextureRect.new()
	var test_texture : Texture  = (equipment.get_item_field("SpiritBomb", Item.TEXTURE))
	print(test_texture)
	texture_rect.texture = test_texture
	texture_rect.set_global_position(Vector2(50,50))
	get_tree().root.call_deferred("add_child",texture_rect)
	var test_scene = equipment.get_item_field("SpiritBomb", Item.SCENE)
	test_scene = test_scene.instance()
	test_scene.global_position = Vector2(150,150)
	get_tree().root.call_deferred("add_child",test_scene)
