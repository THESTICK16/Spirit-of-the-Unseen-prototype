extends KinematicWeapon

#export (Resource) var weapon 
onready var SpiritExplosion = preload("res://SpiritEffects/SpiritExplosion.tscn")
onready var timer = $ExplosionTimer
var effect : Particles2D
var bodies_in_explosion := []
var exploded = false
var spirit_explosion
var max_range := 100

func _ready():
	timer.connect("timeout", self, "explode")
	hitbox.connect("area_entered", self, "_on_HitBox_area_entered")
	hitbox.connect("area_exited", self, "_on_HitBox_area_exited")
#	timer.start()
#	hitbox.set_deferred("monitorable", false)
	hitbox.direction = start_direction
	hitbox.damage = damage
	
func _process(_delta):
	if !timer.is_stopped():
		effect = $SpiritDenseEnergy
	if effect != null:
		var percent_time_left = float ((timer.time_left / timer.wait_time))
		effect.set_deferred("speed_scale", percent_time_left)
	if spirit_explosion != null:
		if spirit_explosion.emitting:
			exploded = true
		if exploded and not spirit_explosion.emitting:
			spirit_explosion.queue_free()
			queue_free()
	

func explode():
	set_deferred("emitting", false)
	effect.call_deferred("hide")
#	knockback_enemies()
	hitbox.set_deferred("monitorable", true)
	if is_instance_valid(user):
		user.can_use_spirit_attack = true
	spirit_explosion = SpiritExplosion.instance()
#	spirit_explosion.global_position = self.global_position
	spirit_explosion.set_deferred("emitting", true)
#	get_tree().root.add_child(spirit_explosion)
	add_child(spirit_explosion)
	spirit_explosion.global_position = self.global_position
#	queue_free()
	#Spirit_expolsion's hitbox remains because the item doe not queue free. fix that
	


func _on_HitBox_area_entered(area):
	bodies_in_explosion.append(area)
	
func knockback_enemies():
	# http://www.iforce2d.net/b2dtut/explosions - this has a better way to do this using raycasts
	for i in hitbox.get_overlapping_areas(): #bodies_in_explosion:
#		if is_instance_valid(i):
		var enemy = i.get_parent()
		if enemy.get("velocity") != null:
			i.get_parent().velocity = global_position.direction_to(i.global_position) * knockback


func _on_HitBox_area_exited(area):
	yield()
	bodies_in_explosion.remove(area)
	
func slide(_delta):
	velocity = start_direction * speed
	move_and_collide(velocity * _delta)
