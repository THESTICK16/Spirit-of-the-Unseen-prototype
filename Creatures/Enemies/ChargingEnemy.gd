extends Enemy


var RETURNING
#enum {
#	IDLE
#	CHARGE
#	RETURNING
#	WANDER
#	STUNNED
#	DEAD
#}

onready var raycast = $RayCast2D
onready var raycast2 = $RayCast2D2
onready var raycast3 = $RayCast2D3
onready var raycasts = [raycast, raycast2, raycast3]

## The direction this enemy will face, this should never change
export var facing_direction := Vector2.DOWN
##The distance that the enemy will check to register and charge the player
export var ray_length := 100
## The default knockback of the enemy when not in motion
export var default_knockback := 100
## The animation that will play based on the direction of the skeleton
var current_anim : String
## The amount that the outer raycasts will be rotated by in radians
const raycast_rotation = 30 #16

func _ready():
	add_state("RETURNING")
	RETURNING = states.get("RETURNING")
	change_state(IDLE) #state = IDLE
	
	hitbox.knockback = self.knockback
	hitbox.direction = self.facing_direction
	
	for i in raycasts:
		i.cast_to = facing_direction * ray_length
	raycast2.rotate(PI / raycast_rotation) #deg2rad(90))
	raycast3.rotate(-PI / raycast_rotation)
	
	match facing_direction:
		Vector2.UP:
			current_anim = "Up"
#			animated_sprite.play("Up")
		Vector2.DOWN:
			current_anim = "Down"
#			animated_sprite.play("Down")
#			detection_area.rotate(PI / 2)
		Vector2.LEFT:
			current_anim = "Left"
#			animated_sprite.play("Left")
		Vector2.RIGHT:
			current_anim = "Right"
#			animated_sprite.play("Right")
#	animated_sprite.play(current_anim)
#	animated_sprite.stop()
#	animated_sprite.frame = 0

func _physics_process(delta):
	match state:
		IDLE:
			idle(delta)
			
		CHASE:
			chase(delta)
			
		RETURNING:
			returning(delta)
			
		STUNNED:
			stunned(delta)
		
		DEAD:
			dead(delta)
			
#	if facing_direction == Vector2.DOWN or facing_direction == Vector2.UP:
#		global_position.x = clamp(global_position.x, start_position.x, start_position.x)
#	if facing_direction == Vector2.LEFT or facing_direction == Vector2.RIGHT:
#		global_position.y = clamp(global_position.y, start_position.y, start_position.y)
		
	velocity = move_and_slide(velocity)
			
func idle(_delta):
	animated_sprite.play(current_anim)
	animated_sprite.stop()
	animated_sprite.frame = 0
	animated_sprite.speed_scale = 1
	
	velocity = velocity.move_toward(Vector2.ZERO, friction * _delta)
	check_for_player()
	if global_position.distance_to(start_position) > 25: #.is_equal_approx(start_position): # != start_position:
		change_state(RETURNING) #state = RETURNING
#	if raycast.is_colliding():
#		player = raycast.get_collider()
#		state = CHARGE
	
func chase(_delta):
	animated_sprite.play(current_anim, false)
	animated_sprite.speed_scale = velocity.length() / 100
	check_for_player()
#	if player != null:
#		velocity = velocity.move_toward(global_position.direction_to(player.global_position) * chase_max_speed, acceleration * _delta)
#	else:
	velocity = velocity.move_toward(facing_direction * chase_max_speed, acceleration * _delta)
	
	if global_position.distance_to(start_position) > max_wander_distance or is_on_wall(): # and player == null:
		change_state(RETURNING) #state = RETURNING
	
func returning(_delta):
	animated_sprite.play(current_anim, true)
	animated_sprite.speed_scale = 1
	velocity = velocity.move_toward(global_position.direction_to(start_position) * max_speed, acceleration * _delta)
	if global_position.distance_to(start_position) < 25: #.is_equal_approx(start_position):
		velocity = velocity / 2
		change_state(IDLE) #state = IDLE
#	check_for_player()
	
	
func stunned(_delta): #upon exiting stunned, enter the 'RETURNING' state
	velocity = velocity.move_toward(Vector2.ZERO, friction * _delta)
	
func dead(_delta):
	if not dead:
		dead = true
#		animated_sprite.play("Die")
		detection_area.set_deferred("monitoring", false)
		hitbox.set_deferred("monitorable", false)
	hurtbox.set_deferred("monitoring", false)
	animated_sprite.play("Die")
	if velocity == Vector2.ZERO:
		velocity = velocity.clamped(0.0)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * _delta)
	
func check_for_player():
	for i in raycasts:
		if i.is_colliding():
			player = i.get_collider()
			change_state(CHASE) #state = CHARGE
		else:
			player = null
			
func take_hit(area):
	if state != STUNNED:
		if area.stuns:
			enter_stunned()
		velocity = area.direction * area.knockback
	hurtbox.start_invincibility(invincibility_duration)
	health -= area.damage
	if health <= 0:
		change_state(DEAD) #state = DEAD
		
func enter_stunned():
	change_state(STUNNED) #state = STUNNED
#	hit_box.get_node("CollisionShape2D").disabled = true
	animated_sprite.stop()
	if stun_timer != null:
		if stun_timer.is_stopped():
			stun_timer.start()
		
func exit_stunned():
	if state == STUNNED:
		change_state(IDLE) #state = IDLE
		
func vanish():
	if state == DEAD:
		rotate(deg2rad(-90))
		yield(get_tree().create_timer(1), "timeout")
		queue_free()
		
func state_changed(new_state):
	match new_state:
		IDLE:
			direction = Vector2.ZERO
			
		CHASE:
			direction = facing_direction
			
			
		RETURNING:
			direction = global_position.direction_to(start_position)
			
		STUNNED:
			direction = Vector2.ZERO
		
		DEAD:
			pass
	
	hitbox.direction = direction
			
func give_hit():
	velocity *= -1
	change_state(RETURNING)
	
func die():
	change_state(DEAD)

#func change_direction():
#	if state == WANDER: # or state == IDLE:
#		if state == IDLE:
#			state = WANDER
#		var next_dir_rand = randi() % 5	
#		match next_dir_rand:
#			0:
#				next_direction = Vector2.UP
#			1:
#				next_direction = Vector2.DOWN
#			2:
#				next_direction = Vector2.LEFT
#			3:
#				next_direction = Vector2.RIGHT
#			4:
#				if state == WANDER:
#					state = IDLE
