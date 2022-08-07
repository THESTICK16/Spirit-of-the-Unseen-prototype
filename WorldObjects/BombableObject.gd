extends StaticBody2D

onready var hurtbox = $HurtBox
onready var animated_sprite = $AnimatedSprite

func _ready():
	if hurtbox != null:
		hurtbox.connect("area_entered", self, "explode")
		
func explode(_area):
#	if animated_sprite.has_animation("explode"):
	animated_sprite.play("explode")
	if animated_sprite.playing:
		yield(animated_sprite, "animation_finished")
	
	queue_free()
