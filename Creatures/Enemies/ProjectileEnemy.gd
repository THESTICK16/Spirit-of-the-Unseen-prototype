extends Enemy

#onready var IDLE = states.get("IDLE")
#onready var CHASE = states.get("CHASE")
#onready var WANDER = states.get("WANDER")
var AIM
#onready var STUNNED = states.get("STUNNED")
#onready var DEAD = states.get("DEAD")
#enum {
#	IDLE
#	WANDER
#	CHASE
#	AIM
#	STUNNED
#	DEAD
#}

## The projectile that the enemy will fire
export (PackedScene) var Projectile
## The distance that the enemy's raycast to detect if the player is in firing range will extend 
export var detection_range := 400
## The distance the player must travel for the enemy to forget about it and move back to wander state
export var forget_player_distance := 350
##The max distance from the player the enemy will be to fire at the player
export var fire_range := 400
## The distance in front of the enemy that their projectile will spawn
export var projectile_offset := 25
## The distance from the player that the enemy will try to be to fire the projectile
export var ideal_aim_distance := 200

## If true, the enemy can fire its projectile again
var can_fire := true
## The current animation of the enemy
var current_anim := "Down"
## The cardinal direction of the enemy (the direction its sprite is facing
var facing_direction := Vector2.DOWN
## The margin for which the enemy can be in to be consiedered in line with the player
const in_line_margin := 10


onready var fire_check_raycast = $FireCheckRayCast2D
onready var fire_check_raycast2 = $FireCheckRayCast2D2
onready var fire_check_raycast3 = $FireCheckRayCast2D3
onready var raycasts = [fire_check_raycast, fire_check_raycast2, fire_check_raycast3]
onready var projectile_recharge_timer = $ProjectileRechargeTimer
onready var projectile_spawn_position = $ProjectileSpawnPosition2D
onready var target_aim_position = $TargetAimPosition2D

func _ready():
	add_state("AIM")
	AIM = states.get("AIM")
	change_state(IDLE)
	randomize()

func _physics_process(delta):
	match state:
		IDLE:
			idle(delta)
		WANDER:
			wander(delta)
		CHASE:
			chase(delta)
		AIM:
			aim(delta)
		STUNNED:
			stunned(delta)
		DEAD:
			dead(delta)
			
#	if abs(direction.x ) > abs(direction.y):
#		if direction.x > 0:
#			facing_direction = Vector2.RIGHT
#			current_anim = "Right"
#		else:
#			facing_direction = Vector2.LEFT
#			current_anim = "Left"
#	elif abs(direction.y) > abs(direction.x):
#		if direction.y > 0:
#			facing_direction = Vector2.DOWN
#			current_anim = "Down"
#		else:
#			facing_direction = Vector2.UP
#			current_anim = "Up"
			
	projectile_spawn_position.position = facing_direction * projectile_offset
	target_aim_position.position = facing_direction * ideal_aim_distance
			
	fire_check_raycast.cast_to = facing_direction * detection_range
	fire_check_raycast2.cast_to = facing_direction * detection_range
	fire_check_raycast3.cast_to = facing_direction * detection_range
	fire_check_raycast2.rotation = rotation + (PI / 16)
	fire_check_raycast3.rotation = rotation + (-PI / 16)
	
	velocity = move_and_slide(velocity)

func idle(_delta):
	check_for_player()
	if is_on_wall():
		change_direction()
		
	animated_sprite.play(current_anim)
	animated_sprite.stop()
	animated_sprite.frame = 0
	
	if player != null:
		change_state(CHASE)
	
	velocity = velocity.move_toward(Vector2.ZERO, friction * _delta)
	
func wander(_delta):
	check_for_player()
	if is_on_wall():
		change_direction()
	
	animated_sprite.play(current_anim)
	
	direction = next_direction
	velocity = velocity.move_toward(next_direction * max_speed, acceleration * _delta)
	
	_update_facing_position(direction)
	
	
func chase(_delta):
	if player == null:
		change_state(IDLE)
		return
	animated_sprite.play(current_anim)
	
	if is_instance_valid(player):
#		direction = target_aim_position.global_position.direction_to(player.global_position)
		var distance_to_player = global_position.distance_to(player.global_position)
		var 	aim_position_distance_to_player = target_aim_position.global_position.distance_to(player.global_position)
		
		var player_center : Vector2
		if player.has_node("SpriteCenterPosition2D"):
			player_center = player.get_node("SpriteCenterPosition2D").global_position
		else:
			player_center = player.global_position
			
		if distance_to_player < aim_position_distance_to_player:
			direction = global_position.direction_to(player_center)
		else:
			direction = target_aim_position.global_position.direction_to(player_center)
			
		_update_facing_position(global_position.direction_to(player.global_position))
#	velocity = velocity.move_toward(global_position.direction_to(player.global_position) * chase_max_speed, acceleration * _delta)

	velocity = velocity.move_toward(direction * chase_max_speed, acceleration * _delta)
		
	if is_in_firing_range():
		change_state(AIM)
		return
	
	check_for_player()
	if player == null:
		change_state(IDLE)
	
func aim(_delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * _delta)
	if is_in_firing_range():
		fire_projectile()
	if not can_fire or player == null:
		change_state(IDLE)
		
func stunned(_delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * _delta)
	
func dead(_delta):
	if not dead:
		die()
#		dead = true
#		detection_area.set_deferred("monitoring", false)
#		hitbox.set_deferred("monitorable", false)
	hurtbox.set_deferred("monitoring", false)
	animated_sprite.play("Die")
	if velocity == Vector2.ZERO:
		velocity = velocity.clamped(0.0)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * _delta)

func change_direction():
	wander_timer.wait_time = rand_range(1, 4)
#	var current_position = global_position
	if get_state() == IDLE:
		change_state(WANDER) #state = WANDER
#	if current_position.distance_to(start_position) > max_wander_distance and get_state() == WANDER:
#		next_direction = current_position.direction_to(start_position)
	if state == WANDER:
		var next_rand = randi() % 5
		
		match next_rand:
			0:
				next_direction = Vector2.UP
			1:
				next_direction = Vector2.DOWN
			2:
				next_direction = Vector2.LEFT
			3:
				next_direction = Vector2.RIGHT
			4:
				change_state(IDLE)
			
func check_for_player():
	if player != null:
		change_state(CHASE)
	for i in raycasts:
		if i.is_colliding():
			player = i.get_collider()
			change_state(CHASE)
	if player != null and is_instance_valid(player):
		if global_position.distance_to(player.global_position) > forget_player_distance:
			player = null
			
func is_in_firing_range() -> bool:
	if player == null:
		return false
		
#	var x_difference = global_position.x - player.global_position.x
#	var y_difference = global_position.y - player.global_position.y
#	if x_difference < in_line_margin or y_difference < in_line_margin: #Instead of this, could just check if in range of middle raycast
	if fire_check_raycast.is_colliding():
		if global_position.distance_to(player.global_position) < fire_range:
			return true
		
	return false
	
func fire_projectile():
	if Projectile == null:
		return
	
	if can_fire:
		var projectile = Projectile.instance()
		projectile.user = self
		projectile.start_direction = facing_direction
		projectile.global_position = projectile_spawn_position.global_position
		get_tree().root.add_child(projectile)
		can_fire = false
		print(can_fire) #FIXME
		projectile_recharge_timer.start()
		yield(projectile_recharge_timer, "timeout")
		can_fire = true
		print(can_fire) #FIXME
		
func _on_DetectionArea_body_exited(_body):
	pass
	
#func enter_stunned():
#	change_state(STUNNED)
#	detection_area.set_deferred("monitoring", false)
#	animated_sprite.stop()
#	if stun_timer != null:
#		if stun_timer.is_stopped():
#			stun_timer.start()
			
#func exit_stunned():
#	if get_state() == STUNNED:
#		detection_area.set_deferred("monitoring", true)
#		change_state(IDLE)
		
func vanish():
	if state == DEAD:
		rotate(deg2rad(-90))
		yield(get_tree().create_timer(1), "timeout")
		queue_free()

#func die():
#	change_state(DEAD)
		

func update_facing_position():
	if abs(direction.x ) > abs(direction.y):
		if direction.x > 0:
			facing_direction = Vector2.RIGHT
			current_anim = "Right"
		else:
			facing_direction = Vector2.LEFT
			current_anim = "Left"
	elif abs(direction.y) > abs(direction.x):
		if direction.y > 0:
			facing_direction = Vector2.DOWN
			current_anim = "Down"
		else:
			facing_direction = Vector2.UP
			current_anim = "Up"
			
func _update_facing_position(moving_toward : Vector2):
	if abs(moving_toward.x ) > abs(moving_toward.y):
		if moving_toward.x > 0:
			facing_direction = Vector2.RIGHT
			current_anim = "Right"
		else:
			facing_direction = Vector2.LEFT
			current_anim = "Left"
	elif abs(moving_toward.y) > abs(moving_toward.x):
		if moving_toward.y > 0:
			facing_direction = Vector2.DOWN
			current_anim = "Down"
		else:
			facing_direction = Vector2.UP
			current_anim = "Up"

