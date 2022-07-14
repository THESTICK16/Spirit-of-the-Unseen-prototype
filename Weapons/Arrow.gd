extends KinematicWeapon

var max_distance = 2000
var hit := false

onready var despawn_timer = $DespawnTimer
onready var shoot_audio = $ShootStreamPlayer2D #preload("res://Assets/Sound/SoundFX/shoot.wav")
onready var stuck_audio = $StuckAudioStreamPlayer

func _ready():
	start_position = global_position
	hitbox.direction = start_direction
	start_direction = fix_direction()
	rotate(set_rotation_direction())
	despawn_timer.connect("timeout", self, "queue_free")
#	SFXController.play_sfx(shoot_audio, false)
	if shoot_audio != null:
		shoot_audio.play()
	
	
func _physics_process(delta):
	if !hit:
		velocity = start_direction * speed
	var collision = move_and_collide(velocity * delta)
	
	if collision != null and not hit:
#		if not stuck_audio.playing and not hit:
#		stuck_audio.play()
		hit = true
		velocity = Vector2.ZERO
		animated_sprite.stop()
		if despawn_timer.is_stopped():
			despawn_timer.start()
		hitbox.set_deferred("monitorable", false)
		stuck_audio.play()
		
#		get_parent().remove_child(self)
#		collision.collider.add_child(self)
#		queue_free()
#		$AnimatedSprite.play("stuck")

	if global_position.distance_to(start_position) > max_distance:
		queue_free()
	
#func set_rotation_direction() -> float:
#	match start_direction:
#		Vector2.UP:
#			return deg2rad(180)
#		Vector2.DOWN:
#			return deg2rad(0)
#		Vector2.LEFT:
#			return deg2rad(90)
#		Vector2.RIGHT:
#			return deg2rad(-90)
##	if start_direction == Vector2(1,1).normalized():
##		return deg2rad(-45)
##	if start_direction == Vector2(-1,1).normalized():
##		return deg2rad(45)
##	if start_direction == Vector2(1,-1).normalized():
##		return deg2rad(-135)
##	if start_direction == Vector2(-1,-1).normalized():
##		return deg2rad(135)
#
#	return 0.0
#
#func fix_direction():
#	if start_direction.x != 0 and start_direction.y != 0:
#		if start_direction == Vector2(1,1).normalized():
#			return Vector2.DOWN
#		if start_direction == Vector2(-1,1).normalized():
#			return Vector2.DOWN
#		if start_direction == Vector2(1,-1).normalized():
#			return Vector2.UP
#		if start_direction == Vector2(-1,-1).normalized():
#			return Vector2.UP
#	else:
#		return start_direction
#


#func _on_AnimatedSprite_animation_finished():
#	queue_free()
