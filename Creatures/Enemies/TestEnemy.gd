extends KinematicBody2D

enum {
	IDLE
	CHASE
	WANDER
	STUNNED
}

var state = IDLE
onready var hit_box = $HitBox
onready var hurt_box = $HurtBox
onready var animated_sprite = $AnimatedSprite
var velocity := Vector2.ZERO
const MAX_HEALTH = 1000
var health = MAX_HEALTH setget set_health
var player
var max_speed = 75
var speed = 25 #the maximum speed the entity will move
var friction = 600 #the rate at which the entity will slow down and speed up when stopping and starting



func _physics_process(delta):
	match state:
		IDLE:
			idle(delta)
			
		CHASE:
			chase(delta)
			
		WANDER:
			pass
			
		STUNNED:
			stunned(delta)
			
	velocity = move_and_slide(velocity)
			
func idle(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
#	rotate(2 * delta)
	
func chase(_delta):
#	rotate(2 * delta)
	if player == null:
		state = IDLE
	else:
		var direction_to_player = global_position.direction_to(player.global_position)
		hit_box.direction = direction_to_player
		velocity = velocity.move_toward(direction_to_player * max_speed, speed)
		
#		move_and_slide(velocity)
	
func stunned(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
func _on_HurtBox_area_entered(area):
	if state != STUNNED:
		if area.stuns:
			enter_stunned()
		velocity = area.global_position.direction_to(global_position).normalized() * area.knockback
	health -= area.damage
	if health <= 0:
		queue_free()

	

func _on_StunTimer_timeout():
	exit_stunned()
	
func enter_stunned():
	state = STUNNED
#	hit_box.get_node("CollisionShape2D").disabled = true
	animated_sprite.stop()
	if $StunTimer.is_stopped():
		$StunTimer.start()
		
func exit_stunned():
#	hit_box.get_node("CollisionShape2D").disabled = false
	state = IDLE
	animated_sprite.play()
	
func set_health(current_health): #implement a boolean or something that makes it so the enemy can't be damaged for a brief momentafter taking a hit
	health = current_health 
	if health <= 0:
		queue_free()


func _on_InvincibilityTimer_timeout():
	hurt_box.get_node("CollisionShape2D").disabled = false


func _on_DetectionArea_body_entered(body):
	player = body
	state = CHASE


func _on_DetectionArea_body_exited(_body):
	player = null
