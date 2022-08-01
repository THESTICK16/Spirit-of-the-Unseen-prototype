extends TileMap

const MapBorder = preload("res://CollisionBoxes/MapBorder.tscn")

func _ready():
	setup_area2d()
	setup_map_border()

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
	
	add_child(area)
	
func setup_map_border():
	var tilemap_rect : Rect2 = get_used_rect()
	var tilemap_cell_size = cell_size
	var top_left_position = Vector2(tilemap_rect.position.x * tilemap_cell_size.x, tilemap_rect.position.y * tilemap_cell_size.y)
	var bottom_right_position = Vector2(tilemap_rect.size.x + tilemap_rect.position.x, tilemap_rect.size.y + tilemap_rect.position.y) * tilemap_cell_size
	var shape_thickness := 25
	
	var top_map_border = MapBorder.instance()
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.set_extents(Vector2((tilemap_rect.size.x * tilemap_cell_size.x) / 2, shape_thickness)) #(Vector2((bottom_right_position.x - top_left_position.x) / 2, 20))
	top_map_border.position = Vector2(top_left_position.x + (tilemap_rect.size.x * tilemap_cell_size.x) / 2, top_left_position.y) #Vector2((bottom_right_position.x - top_left_position.x) / 2, top_left_position.y)
	top_map_border.add_child(collision_shape)
	add_child(top_map_border)
	
#	var bottom_map_border = MapBorder.instance()
#	collision_shape = CollisionShape2D.new()
#	collision_shape.shape = RectangleShape2D.new()
#	collision_shape.shape.set_extents(Vector2((tilemap_rect.size.x * tilemap_cell_size.x) / 2, shape_thickness)) #(Vector2((bottom_right_position.x - top_left_position.x) / 2, 20))
#	bottom_map_border.position = Vector2(top_left_position.x + (tilemap_rect.size.x * tilemap_cell_size.x) / 2, bottom_right_position.y) #Vector2((bottom_right_position.x - top_left_position.x) / 2, top_left_position.y)
#	bottom_map_border.add_child(collision_shape)
#	add_child(bottom_map_border)
	
	var left_map_border = MapBorder.instance()
	collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.set_extents(Vector2(2, (tilemap_rect.size.y * tilemap_cell_size.y) / 2)) #(Vector2((bottom_right_position.x - top_left_position.x) / 2, 20))
	left_map_border.position = Vector2(top_left_position.x, bottom_right_position.y - (tilemap_rect.size.y * tilemap_cell_size.y) / 2) #Vector2((bottom_right_position.x - top_left_position.x) / 2, top_left_position.y)
	left_map_border.add_child(collision_shape)
	add_child(left_map_border)
	
#	var right_map_border = MapBorder.instance()
#	collision_shape = CollisionShape2D.new()
#	collision_shape.shape = RectangleShape2D.new()
#	collision_shape.shape.set_extents(Vector2(2, (tilemap_rect.size.y * tilemap_cell_size.y) / 2)) #(Vector2((bottom_right_position.x - top_left_position.x) / 2, 20))
#	right_map_border.position = Vector2(bottom_right_position.x, bottom_right_position.y - (tilemap_rect.size.y * tilemap_cell_size.y) / 2) #Vector2((bottom_right_position.x - top_left_position.x) / 2, top_left_position.y)
#	right_map_border.add_child(collision_shape)
#	add_child(right_map_border)
