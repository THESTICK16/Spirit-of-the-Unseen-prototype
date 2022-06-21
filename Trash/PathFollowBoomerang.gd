extends KinematicBody2D

var weapon_class := "Ranged"
var damage := 0.0 #This weapon stuns and breaks items, not damages enemies
var speed := 400
var rotation_speed := 25
var player
var return_location : Vector2
onready var start_position = global_position
var start_direction = Vector2.ZERO
var max_distance = 600
var velocity : Vector2
var returning := false
onready var path_follow = get_parent()

func _physics_process(delta):
	rotate(rotation_speed * delta)
	path_follow.set_offset(path_follow.get_offset() + speed * delta)
