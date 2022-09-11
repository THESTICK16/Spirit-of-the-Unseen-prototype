## This scene enables all transitions between scenes and rooms to take place
## Used for entering buildings/caves, changing rooms in a building/dungeon, etc.
## Naming convention should be [CurrentRoomName]To[RoomToTransitionToName]ChangeSceneArea, in order to make transitions work programatically
extends Area2D
class_name ChangeSceneArea

## If true, entering this door will load an entirely new scene (var next_scene)
export var change_scene_door := false
## If true, entering this door will transport the player to another position within the same scene (var next_position)
export var change_position_door := false
## The path to the room that will load when the player enters the door
export (String) var next_scene
## The position that the player will be moved to when they enter the door, must have a global_position
export var next_position : Vector2
## The Direction that the player would be facing as they "exit" the door
export (Vector2) var exit_direction := Vector2.DOWN
## The distance from the center of this door the player should be placed when it is "exited" in pixels
export var spawn_spacing := 32

onready var exit_spawn_position = $ExitSpawnPosition2D
## The name of the door from which the player will "exit" in the next scene
onready var door_to_exit_from_name

func _ready():
	connect("body_entered", self, "change_room")
	exit_direction = Calculations.make_vector_directional(exit_direction)
	exit_spawn_position.position += exit_direction * spawn_spacing
	setup_names()
	
	if not is_in_group("ChangeSceneAreas"):
		add_to_group("ChangeSceneAreas")

## Depending on the status of the door type variables, this function loads a new scene or moves the players position to a new room's position
## Called by the on body entered signal of this Area2D
## @param body The body that entered the door (Area2D) 
func change_room(body):
	if body is Player:
		if change_scene_door:
			TransitionController.change_to_new_scene_and_set_player_position(next_scene, self)
#			get_tree().change_scene_to(next_scene)
		elif change_position_door:
			body.global_position = next_position
			
## Ensures that the name of this scene matches the proper format to assist with loading the player's spawn position upon entry
func setup_names():
	var scene_name : String = get_tree().current_scene.name # The name of the current scene
	var scene_to_load_name : String = get_scene_to_load_name() # The name of the scene to be loaded by this area
#	if scene_to_load_name == "" or scene_to_load_name == null:
#		return
	var new_name : String = format_name(scene_name, scene_to_load_name) #scene_name + "To" + scene_to_load_name + "ChangeSceneArea"
	self.set_name(new_name)
	
	door_to_exit_from_name = format_name(scene_to_load_name, scene_name)

## Parses the next_scene var and returns the name of the scene from the scene path
func get_scene_to_load_name() -> String: 
	#res://Levels/HouseInterior.tscn
	var scene_to_load_name : String
	var next_scene_path : String = next_scene
	
	if not next_scene_path.ends_with(".tscn"):
		return ""
		
	scene_to_load_name = next_scene_path.get_slice("/", next_scene_path.count("/"))
	scene_to_load_name = scene_to_load_name.trim_suffix(".tscn")
	return scene_to_load_name

func format_name(from : String, to : String) -> String:
	var formatted_name: String = from + "To" + to + "ChangeSceneArea"
	
	return formatted_name
	
func get_player_exit_position() -> Vector2:
	return exit_spawn_position.global_position
