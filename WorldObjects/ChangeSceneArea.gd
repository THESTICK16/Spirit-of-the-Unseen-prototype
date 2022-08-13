## This scene enables all transitions between scenes and rooms to take place
## Used for entering buildings/caves, changing rooms in a building/dungeon, etc.
extends Area2D

## If true, entering this door will load an entirely new scene (var next_scene)
export var change_scene_door := false
## If true, entering this door will transport the player to another position within the same scene (var next_position)
export var change_position_door := false
## The path to the room that will load when the player enters the door
export (String) var next_scene
## The position that the player will be moved to when they enter the door, must have a global_position
export var next_position : Vector2

func _ready():
	connect("body_entered", self, "change_room")

## Depending on the status of the door type variables, this function loads a new scene or moves the players position to a new room's position
## Called by the on body entered signal of this Area2D
## @param body The body that entered the door (Area2D) 
func change_room(body):
	if body is Player:
		if change_scene_door:
			TransitionController.change_to_new_scene(next_scene)
#			get_tree().change_scene_to(next_scene)
		elif change_position_door:
			body.global_position = next_position
