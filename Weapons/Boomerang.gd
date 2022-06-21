extends KinematicBody2D
#Make a new boomerang script that inherits from kinematicweapon and uses the user var instead of player

var weapon_name = "Boomerang"
var weapon_class := "Ranged"
var damage := 0.0 #This weapon stuns and breaks items, not damages enemies
var stuns := true
var speed := 400
var rotation_speed := 25
var player
var return_location : Vector2
onready var start_position = global_position
var start_direction = Vector2.ZERO
var max_distance = 375
var velocity : Vector2
var returning := false
onready var curve_intensity = get_curve(start_direction) * speed
onready var curve = curve_intensity #get_curve(start_direction) * speed
onready var hitbox = $HitBox
var current_direction : Vector2


func _physics_process(delta):
	#move(delta)
	move_with_curve(delta)

##	curve += delta
#
#	if player != null:
#		return_location = player.global_position
#	else:
#		return_location = start_position
#
#	var distance = sqrt( pow(abs(global_position.x - start_position.x), 2) + pow(abs(global_position.y - start_position.y), 2))
#
#	rotate(rotation_speed * delta)
#
#	if returning and global_position.distance_to(return_location) < 60:
#		queue_free()
#		if player != null:
#			player.can_throw_boomerang = true
#
#
#	if distance >= max_distance:
#		returning = true
#
#	if !returning:
#		velocity = start_direction * speed
#		velocity += curve
#		curve = curve.move_toward( curve_intensity * -1, (max_distance * 2) * delta)
##		velocity = curve * speed
#
#
##		if global_position.distance_to(target_arc(start_direction, start_position)) < 10:
##			arc_peak_reached = true
#
##		if !arc_peak_reached:
##			curve += get_curve(start_direction) * curve_reduction
##		elif arc_peak_reached:
##			curve -= get_curve(start_direction) * curve_reduction
#
##		curve += ( PI) * delta / float(duration) 
##		curve = wrapf(curve, -PI, PI)
##		var arc = Vector2()
##		arc.x = cos(curve) * (max_distance / 2)
##		arc.y = sin(curve) * (max_distance / 2)
##		if (start_direction.x != 0):
##			arc.x *= start_direction.x
##		if (start_direction.y != 0):
##			arc.y *= start_direction.y
#
##		var arc = Vector2(cos(curve * 3) * (max_distance / 2), sin(curve * 3) * (max_distance / 2))
#
##		curve += curve(start_direction, start_position, global_position)
##		velocity += curve
#
#	elif returning:
#		if player != null:
#			return_location = player.global_position
#		else:
#			return_location = start_position
#		velocity = global_position.direction_to(return_location) * speed
#		if velocity.normalized().x + velocity.normalized().y > speed:
#			velocity = global_position.direction_to(return_location) * speed
#
#	else:
#		velocity = Vector2.ZERO
#
#	#Make sure that speed remains constant throughout the boomerang's path. boomerangs do not slow down as they change direction, they just redirect their speed (velocity)
#
#	move_and_collide(velocity.clamped(speed) * delta)
##	move_and_collide(velocity * delta)
#
func move_straight(delta):
	if player != null:
		return_location = player.global_position
	else:
		return_location = start_position
		
	var distance = sqrt( pow(abs(global_position.x - start_position.x), 2) + pow(abs(global_position.y - start_position.y), 2))
	
	rotate(rotation_speed * delta)
	
	if returning and global_position.distance_to(return_location) < 60:
		queue_free()
		if player != null:
			player.can_throw_boomerang = true
	
	
	if distance >= max_distance:
		returning = true
		
	if !returning:
		velocity = start_direction * speed
		current_direction = start_direction
		
	elif returning:
		$CollisionShape2D.disabled = true
		if player != null:
			return_location = player.global_position
		else:
			return_location = start_position
		current_direction = global_position.direction_to(return_location)
		velocity = current_direction * speed
		if velocity.normalized().x + velocity.normalized().y > speed:
			velocity = global_position.direction_to(return_location) * speed
		
	else:
		velocity = Vector2.ZERO
		
	hitbox.direction = current_direction
	var collision = move_and_collide(velocity.clamped(speed) * delta)
#	move_and_collide(velocity * delta)
	if collision != null:
		returning = true
		
func move_with_curve(delta):
	if player != null:
		return_location = player.global_position
	else:
		return_location = start_position
		
	var distance = sqrt( pow(abs(global_position.x - start_position.x), 2) + pow(abs(global_position.y - start_position.y), 2))
	
	rotate(rotation_speed * delta)
	
	if returning and global_position.distance_to(return_location) < 60:
		queue_free()
		if player != null:
			player.can_throw_boomerang = true
	
	
	if distance >= max_distance:
		returning = true
		
	if !returning:
		velocity = start_direction * speed
		velocity += curve
		curve = curve.move_toward( curve_intensity * -1, (max_distance * 2) * delta)
		current_direction = velocity.clamped(1)
		
	elif returning:
		$CollisionShape2D.disabled = true
		if player != null:
			return_location = player.global_position
		else:
			return_location = start_position
		current_direction = global_position.direction_to(return_location)
		velocity = current_direction * speed
		if velocity.normalized().x + velocity.normalized().y > speed:
			velocity = global_position.direction_to(return_location) * speed
		
	else:
		velocity = Vector2.ZERO
		
	hitbox.direction  = current_direction
	var collision = move_and_collide(velocity.clamped(speed) * delta)
#	move_and_collide(velocity * delta)
	if collision != null:
		returning = true
		
	
func get_curve(direction : Vector2) -> Vector2:
	if direction.x != 0 and direction.y != 0:
		if direction == Vector2(1, 1).normalized():
			return Vector2(1, -1)
			
		if direction == Vector2(1, -1).normalized():
			return Vector2(-1, -1)
			
		if direction == Vector2(-1, -1).normalized():
			return Vector2(-1, 1)
			
		if direction == Vector2(-1, 1).normalized():
			return Vector2(1, 1)
	
	match direction:
		Vector2.UP:
			return Vector2.LEFT
		
		Vector2.DOWN:
			return Vector2.RIGHT
			
		Vector2.LEFT:
			return Vector2.DOWN
			
		Vector2.RIGHT:
			return Vector2.UP
	
	return Vector2.ZERO
	
	
func apply_curve(direction : Vector2, start_pos : Vector2, current_pos : Vector2) -> Vector2:
	var target_arc = start_pos
	var k = 0.015 # the constant in Hooke's law
	var x # the difference between the height of the arc and the current position
	var force = Vector2.ZERO
	
	match direction:
		Vector2.UP:
			target_arc.x -= max_distance / 2
			x = current_pos.x - target_arc.x
			force = Vector2(-k * x, 0)
		
		Vector2.DOWN:
			target_arc.x += max_distance / 2
			x = current_pos.x - target_arc.x
			force = Vector2(-k * x, 0)
			
		Vector2.LEFT:
			target_arc.y += max_distance / 2
			x = current_pos.y - target_arc.y
			force = Vector2(0, -k * x)
			
		Vector2.RIGHT:
			target_arc.y -= max_distance / 2
			x = current_pos.y - target_arc.y
			force = Vector2(0, -k * x)
			
	
	return force
	

func target_arc(direction : Vector2, start_pos: Vector2) -> Vector2:
	var target_arc = start_pos
	
	match direction:
		Vector2.UP:
			target_arc.x -= max_distance / 4
			target_arc.y -= max_distance / 4
		
		Vector2.DOWN:
			target_arc.x += max_distance / 4
			target_arc.y += max_distance / 4
			
		Vector2.LEFT:
			target_arc.y += max_distance / 4
			target_arc.x -= max_distance / 4
			
		Vector2.RIGHT:
			target_arc.y -= max_distance / 4
			target_arc.x += max_distance / 4
	
	return target_arc
