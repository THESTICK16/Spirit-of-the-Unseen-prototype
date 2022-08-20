extends Node

var equipment = Equipment

func _ready():
#	yield()
#	test_get_item_field()
#	print(ceil(sqrt(24)))
#	print(Equipment.get_item_field("Arrow", ConsumableItem.CURRENT_STOCK))
#	DialogueLoader.create_dialogue_box("/Users/ryorke16/Documents/Godot Projects/Spirit of the Unseen Prototype/Dialogue JSONs/TestDialogue.json")
#	print(equipment.get_item_field("Arrow", Item.ACQUISITION_MESSAGE))
#	test_input_map_stuff()
#	Input.connect("joy_connection_changed", self, "controller_changed")
#	if Input.is_joy_known(0):
#			print("Recognized " + str(Input.get_joy_name(0)))
	SFXController.play_sfx(load("res://Assets/Sound/SoundFX/IceShatter.wav"))
	SFXController.play_sfx(load("res://Assets/Sound/SoundFX/open chest.wav"))
	SFXController.play_sfx(load("res://Assets/Sound/SoundFX/rumble_shortened.wav"))
	SFXController.play_sfx(load("res://Assets/Sound/SoundFX/qubodup-DoorClose01.wav"))
	print(get_tree().current_scene.filename)
	
	
#func _unhandled_input(event):
##	if event.device != 0:
#	if Input.is_joy_button_pressed(0, JOY_DPAD_UP):
#		print("UP")
#	if Input.is_joy_button_pressed(0, JOY_DPAD_DOWN):
#		print("Down")
#
#	if not event is InputEventMouseMotion:
#		print(event)
#
#		print("Controller connected " + str(Input.get_connected_joypads()))
	
func controller_changed(device_id, is_connected):
	if is_connected:
		print("controller " + str(device_id) + " connected")
		if Input.is_joy_known(0):
			print("Recognized " + str(Input.get_joy_name(0)))
	else:
		 print("controller disconnected")
		
		
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

func test_input_map_stuff():
	print(InputMap.has_action("a"))
	var new_key = InputEventKey.new()
	new_key.set_scancode(32)
	if InputMap.action_has_event("ui_accept", new_key):
		print("Input Map has " + str(OS.get_scancode_string(new_key.scancode)))
		InputMap.action_erase_event("ui_accept", new_key)
	else:
		print("does not have the event")
	
	var action_list = InputMap.get_action_list("ui_accept")
	print(action_list)
	for i in action_list:
		if i is InputEventKey:
			print(i.scancode)
	
	var new_key2 = InputEventKey.new()
	new_key2.set_scancode(32)
	print(new_key.scancode == new_key2.scancode)
#	print(InputMap.get_action_list("ui_accept"))
#	if InputMap.action_has_event():
#		pass
#	InputMap.action_erase_event("ui_accept", 32)
#	print(InputMap.get_action_list("ui_accept"))
