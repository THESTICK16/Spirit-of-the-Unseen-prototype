extends Node

func _ready():
	call_deferred("acquire_all_items")
	push_warning("This script is setting the player to have acquired items they should not have for debug purposes. it is attached to " + get_parent().name)
	
func acquire_all_items():
	var all_items = Equipment.all_items
	for item in all_items:
		if item != "Boomerang" and item != "SpiritBomb":
			Equipment.get_item_resource(item).set_player_has_item(true)
