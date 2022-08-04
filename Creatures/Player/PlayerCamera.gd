extends Camera2D

#func _ready():
#	set_extents()

func set_extents(tilemap : TileMap = get_tilemap()):
#	tilemap : TileMap = get_tilemap()
	if tilemap == null:
		return
		
	var tilemap_rect : Rect2 = tilemap.get_used_rect()
	var tilemap_cell_size = tilemap.cell_size
	
	limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	limit_top = tilemap_rect.position.y * tilemap_cell_size.y
	limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y
	
func get_tilemap():
	if get_tree().has_group("Tilemaps"):
		var tilemaps = get_tree().get_nodes_in_group("Tilemaps")
		for map in tilemaps:
			var map_name : String = map.name
			if map_name.to_lower().ends_with("layer0tilemap"):
				return map
		
func get_new_extents(tilemap : TileMap):
	var new_limits = {}
	
	if tilemap == null:
		return new_limits
		
	var tilemap_rect : Rect2 = tilemap.get_used_rect()
	var tilemap_cell_size = tilemap.cell_size
	
	new_limits["limit_left"] = tilemap_rect.position.x * tilemap_cell_size.x
	new_limits["limit_right"] = tilemap_rect.end.x * tilemap_cell_size.x
	new_limits["limit_top"] = tilemap_rect.position.y * tilemap_cell_size.y
	new_limits["limit_bottom"] = tilemap_rect.end.y * tilemap_cell_size.y
	
	return new_limits
