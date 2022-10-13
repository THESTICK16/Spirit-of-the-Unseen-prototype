extends Node

var exempt_items := [
	"Boomerang", 
	"SpiritBomb"
]

func _ready():
	call_deferred("acquire_all_items")
	push_warning("This script is setting the player to have acquired items they should not have for debug purposes. it is attached to " + get_parent().name)
#	get_paths_of_children(get_parent())
	
func acquire_all_items():
	var all_items = Equipment.all_items
	for item in all_items:
		if not exempt_items.has(item):
#		if item != "Boomerang" and item != "SpiritBomb":
			Equipment.get_item_resource(item).set_player_has_item(true)

func get_paths_of_children(start_scene):
	if start_scene.get_child_count() > 0:
		for i in start_scene.get_children():
			get_paths_of_children(i)
#			yield(get_tree().create_timer(0.2), "timeout")
#	if "DemoDungeon" in str(start_scene.get_path()):
	if not str(start_scene.get_path()).begins_with("/root/Dungeon/"):
		print(start_scene.get_path())
