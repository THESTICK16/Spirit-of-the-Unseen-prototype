extends TileMap

func _ready():
	setup_area2d()

func setup_area2d():
	var tilemap_rect : Rect2 = get_used_rect()
	var tilemap_cell_size = cell_size
	var top_left_position = Vector2(tilemap_rect.position.x * tilemap_cell_size.x, tilemap_rect.position.y * tilemap_cell_size.y) #Vector2(tilemap_rect.size.x + (tilemap_cell_size.x * tilemap_rect.position.x), tilemap_rect.size.y + (tilemap_cell_size.y * tilemap_rect.position.y))
	var area_position = top_left_position + ((tilemap_rect.size * tilemap_cell_size) / 2) #- tilemap_cell_size
#	print("Top left: " + str(top_left_position))
	
	var area = Area2D.new()
	var area_collision = CollisionShape2D.new()
	area_collision.shape = RectangleShape2D.new()
	area_collision.shape.set_extents((tilemap_rect.size * tilemap_cell_size) / 2)
#	print("ldksndn") #FIXME
#	print(tilemap_rect.position) #FIXME
#	print(tilemap_rect.size) #FIXME
	area.add_child(area_collision)
	area.position = area_position #top_left_position + ((tilemap_rect.size * tilemap_cell_size) / 2) #- tilemap_cell_size
#	print((tilemap_rect.size * tilemap_cell_size)) #FIXME
	area.set_collision_mask_bit(12, true)
	area.set_collision_layer_bit(0, false)
	area.set_collision_mask_bit(0, false)
	print(str(area.collision_layer) + "; " + str(area.collision_mask))
	add_child(area)
