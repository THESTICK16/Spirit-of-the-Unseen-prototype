## The base scene for a standard wandering enemy, such as snakes, bats, and rats
## @desc:
## All wandering enemy types will inherit from this scene.
## Describes the movement and behavior patterns for the most basic enemy types
## All damage is done by colliding this enemy type's body with the player directly (no weapons or anything)
extends Enemy

## An enumeration of the different states the enemy can be in. To be checked with a match statement
#enum {
#	IDLE
#	CHASE
#	WANDER
#	STUNNED
#	JUMP
#	DEAD
#}

# Should I make an "Enemy Stats" node that I can attach to all enemies and is specific to enemies, thereby negating the need to copy and paste code from each enemy type?
# It would hold almost all of the vars listed below as well as setter and getter functions for health and emit necessary signals for stat changes

## The current state the enemy is in. Will influence enemy behavior
#var state = IDLE
#onready var detection_area = $DetectionArea
#onready var hitbox = $HitBox
#onready var hurtbox = $HurtBox
#onready var animated_sprite = $AnimatedSprite
#onready var stun_timer = $StunTimer
##onready var invincibility_timer = $InvincibilityTimer
#onready var wander_timer = $WanderTimer
### The starting position of the enemy, to be used in the wander state to ensure movement is not to far
#onready var start_position = global_position
#
### The maximum health the enemy can have
#export var max_health := 5
### The current total health points of the enemy
#onready var health := max_health setget set_health
### The player, this field should only have a value if the player is in the enemy's detection zone, else it should be set to null
#var player
### Wheather the enemy is dead or not, limits certain function calls if true
#var dead := false
### The maximum speed the enemy will move
#export var max_speed := 75
### The speed the enemy will move when chasing the player
#export var chase_max_speed := 150
### The rate at which the enemy will speed up when moving
#export var acceleration := 300 
### The rate at which the enemy will slow down when stopping
#export var friction := 600 
### The amount of damage the enemy will do when it collides with the player
#export var damage := 10
### The degree to which the enemy will knock back those it collides with
#export var knockback := 0
### Whether or not the enemy stuns those it collides with
#export var stuns := false
### The maximum distance the enemy can wander in its wander state from the position it starts in
#export var max_wander_distance := 500
### The next direction in which the enemy will wander
#onready var next_direction := self.global_position

func _ready():
	change_state(IDLE) #state = IDLE
#	if detection_area != null:
#		detection_area.connect("body_entered", self, "_on_DetectionArea_body_entered")
#		detection_area.connect("body_exited", self, "_on_DetectionArea_body_exited")
#	if hurtbox != null:
#		hurtbox.connect("area_entered", self, "_on_HurtBox_area_entered")
#	if stun_timer != null:
#		stun_timer.connect("timeout", self, "_on_StunTimer_timeout")
##	if invincibility_timer != null:
##		invincibility_timer.connect("timeout", self, "_on_InvincibilityTimer_timeout")
#	if animated_sprite != null:
#		animated_sprite.connect("animation_finished", self, "vanish")
#	if wander_timer != null:
#		wander_timer.connect("timeout", self, "change_direction")
#	if hitbox != null:
#		hitbox.damage = damage
#		hitbox.knockback = knockback
#		hitbox.stuns = stuns
	randomize()
	
	print(str(name) + ": " + str(get_collision_mask_bit(13)))

func _physics_process(delta):
	match state:
		IDLE:
			idle(delta)
			
		CHASE:
			chase(delta)
			
		WANDER:
			wander(delta)
			
		STUNNED:
			stunned(delta)
		
		DEAD:
			dead(delta)
		
#	if animated_sprite.animation == "Walk":
#		animated_sprite.speed_scale = velocity.length() / 100
#	else:
#		animated_sprite.speed_scale = 1
	animated_sprite.flip_h = direction.x > 0
	velocity = move_and_slide(velocity)

			
func idle(delta):
	if is_on_wall():
		change_direction()
	animated_sprite.play("Idle")
	if player != null:
		change_state(CHASE) #state = CHASE
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
func chase(_delta):
	animated_sprite.play("Walk")
	if player == null:
		change_state(IDLE) #state = IDLE
	else:
		var direction_to_player = global_position.direction_to(player.global_position)
		if direction_to_player != Vector2.ZERO:
			hitbox.direction = direction_to_player
		direction = direction_to_player
		velocity = velocity.move_toward(direction_to_player * chase_max_speed, acceleration * _delta)
		
func wander(_delta):
	animated_sprite.play("Walk")
#	animated_sprite.speed_scale = next_direction.length()
	if is_on_wall():
		change_direction()
#		next_direction *= -1
	direction = next_direction
	velocity = velocity.move_toward(next_direction * max_speed, acceleration * _delta)
#	velocity = velocity.move_toward(global_position.direction_to(next_direction) * max_speed, speed * _delta)
	
func stunned(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
func dead(delta):
	if not dead:
		die()
#		dead = true
##		animated_sprite.play("Die")
#		detection_area.set_deferred("monitoring", false)
#		hitbox.set_deferred("monitorable", false)
	hurtbox.set_deferred("monitoring", false)
	animated_sprite.play("Die")
	if velocity == Vector2.ZERO:
		velocity = velocity.clamped(0.0)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
func take_hit(area):
	if state != STUNNED:
		if area.stuns:
			enter_stunned()
		velocity = area.direction * area.knockback
	hurtbox.start_invincibility(invincibility_duration)
	health -= area.damage
	if health <= 0:
		change_state(DEAD) #state = DEAD

func _on_StunTimer_timeout():
	exit_stunned()
	
func enter_stunned():
	change_state(STUNNED) #state = STUNNED
	detection_area.set_deferred("monitoring", false)
#	hit_box.get_node("CollisionShape2D").disabled = true
	animated_sprite.stop()
	if stun_timer != null:
		if stun_timer.is_stopped():
			stun_timer.start()
		
func exit_stunned():
	if state == STUNNED:
		detection_area.set_deferred("monitoring", true)
		change_state(IDLE) #state = IDLE
	
func set_health(current_health): #implement a boolean or something that makes it so the enemy can't be damaged for a brief momentafter taking a hit
	health = current_health 
	if health <= 0:
		change_state(DEAD) #state = DEAD

func _on_DetectionArea_body_entered(_body):
	player = _body
	change_state(CHASE) #state = CHASE


func _on_DetectionArea_body_exited(_body):
	player = null
	
func die():
	dead = true
#	animated_sprite.play("Die")
	detection_area.set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false)
	change_state(DEAD)

func vanish():
	if state == DEAD:
		queue_free()
		
func change_direction():
	wander_timer.wait_time = rand_range(1, 4)
	var current_position = global_position
	if state == IDLE:
		change_state(WANDER) #state = WANDER
	if current_position.distance_to(start_position) > max_wander_distance and state == WANDER:
		next_direction = current_position.direction_to(start_position)
	elif rand_range(0, 10) > 9:
		change_state(IDLE) #state = IDLE
	else:
		next_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
#		next_direction = Vector2(global_position.x + rand_range(-200, 200), global_position.y + rand_range(-200, 200))

func give_hit():
	velocity = velocity * -1
	
func change_state(new_state):
	if get_state() != DEAD:
		state = new_state
	emit_signal("state_changed", new_state)
