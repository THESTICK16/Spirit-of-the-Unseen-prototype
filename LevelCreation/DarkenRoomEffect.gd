extends Node2D

onready var detection_area = $DetectionArea
onready var collision_shape = $DetectionArea/CollisionShape2D
onready var color_rect = $ColorRect

func _ready():
	if detection_area != null:
		detection_area.connect("body_entered", self, "brighten")
		detection_area.connect("body_exited", self, "darken")
	if collision_shape != null:
		var rectangle_shape : RectangleShape2D = RectangleShape2D.new()
		if color_rect != null:
			rectangle_shape.extents = Vector2(color_rect.rect_size.x / 2,color_rect.rect_size.y / 2)
			detection_area.position = rectangle_shape.extents
#		color_rect.rect_size = collision_shape.shape = RectangleShape2D.new()
		collision_shape.shape = rectangle_shape
	if detection_area.get_overlapping_bodies().size() > 0:
		brighten(KinematicBody2D.new())
	else:
		darken(KinematicBody2D.new())

func darken(_body):
	color_rect.show()

func brighten(_body):
	color_rect.hide()
