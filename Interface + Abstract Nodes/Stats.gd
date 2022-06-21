## Contains the stats for this node's parent
extends Node

#const SAVE_FILE_PATH := ""  #example: "user://savedata.save"

#Stats that are largely static, set before starting the game and will only be changed through method calls and not from physics process
export var MAX_SPEED := 0  
export var acceleration := 0  
export var friction := 0  
export var MAX_HEALTH := 1
onready var health = MAX_HEALTH setget set_health
export var stunnable := true
export var damageable := true
export var damage := 0
export var stuns := false

#Hidden stats that are initially 0 and changed in physics process

#Signals
signal no_health

func set_health(new_health):
	health = new_health
	if health <= 0:
		emit_signal("no_health")

#Maybe call save and load from the player script, that way enemies are not loading stats they should not have
#func _ready():
#	load_stats()

#called externally on saves
func save_stats():
	pass
	
#may be unnecesary to save as a file. Instead, reference the singleton
func load_stats():
	pass
	
#func private_set(value):
#	print("Private variable, cannot change from other scripts")
