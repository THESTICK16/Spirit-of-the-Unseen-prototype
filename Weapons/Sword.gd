extends KinematicWeapon

#onready var animated_sprite = $AnimatedSprite

func _ready():
	if animated_sprite != null:
		animated_sprite.connect("animation_finished", self, "queue_free")
		animated_sprite.frame = 0
	start_direction = fix_direction()
	$HitBox.direction = start_direction
	rotate(set_rotation_direction())
	if animated_sprite != null:
		animated_sprite.play("swing")
	

