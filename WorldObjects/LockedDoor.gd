extends StaticBody2D


var open := false setget set_open

onready var sprite = $Sprite
onready var collision_shape = $CollisionShape2D
onready var interactable_area = $InteractableArea
onready var audio_stream_player = $AudioStreamPlayer
onready var lock_sprite = $LockSprite

### If true, the door will vanish when it is unlocked, else the door will remain without its lock and a new scene should be loaded
#export var vanish_on_unlock := true
### The path to the scene to load if the door transitions to a new scene. If not transitioning, leave blank
#export var scene_to_load : String

func set_open(is_open):
	open = is_open
	if open:
		audio_stream_player.connect("finished", self, "queue_free") #Use this for doors that shpuld disappear when unlocked
#		if is_instance_valid(lock_sprite):
#			audio_stream_player.connect("finished", lock_sprite, "queue_free")
		audio_stream_player.play()
		
		
#		collision_shape.set_deferred("disabled", true)
#		interactable_area.set_deferred("monitorable", false)
#		sprite.hide()
#		queue_free()
	if not open:
		collision_shape.set_deferred("disabled", false)
#		interactable_area.set_deferred("monitorable", true)
		interactable_area.set_deferred("disabled", true)
		sprite.show()

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
	# Make a json for dialoge about warnings or something that includes a line for "You need a key to open this door"
	if not open:
		if PlayerStats.dungeon_keys > 0:
			set_open(true)
			PlayerStats.dungeon_keys -= 1
		else:
			DialogueLoader.create_dialogue_box(JSONFilePaths.MISCELLANEOUS_MESSAGES_JSON_FILEPATH, "NeedKey")
#	if open:
#		enter_door()

#func enter_door():
#	if scene_to_load != "" and scene_to_load != null:
#		TransitionController.change_to_new_scene(scene_to_load)

