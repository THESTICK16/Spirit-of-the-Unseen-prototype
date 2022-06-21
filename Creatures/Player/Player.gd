extends KinematicBody2D

#export (PackedScene) var Boomerang
var Boomerang = preload("res://Weapons/Boomerang.tscn")
var Arrow = preload("res://Weapons/Arrow.tscn")

enum{
	IDLE
	WALK
	ATTACK
	USE_ITEM
}

var max_health = 100
var health = max_health
var speed = 200
var direction = Vector2.RIGHT
var equiped_item
var velocity = Vector2.ZERO
var hit_knockback : Vector2
var friction = 800
var state = IDLE
var invincibility_time = 0.25
var equipped_item : NodePath
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var hurt_box = $HurtBox
onready var animation_state = animation_tree.get("parameters/playback")
onready var sword =$SwordPivot/Sword

#-----------------------------------------------------------
		#Weapon VARS
var can_throw_boomerang := true
var can_fire_arrow := true
#------------------------------------------------------------

func _physics_process(delta):
	hit_knockback = hit_knockback.move_toward(Vector2.ZERO, friction * delta)
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if velocity != Vector2.ZERO:
		direction = velocity.normalized()
#		sword.get_node("HitBox").direction = direction
		animation_tree.set("parameters/Idle/blend_position", direction)
		animation_tree.set("parameters/Walk/blend_position", direction)
		animation_tree.set("parameters/Attack/blend_position", direction)
		
	match state:
		IDLE:
			idle(delta)
			
		WALK:
			walk(delta)	
			
		ATTACK:
			attack(delta)
		
		USE_ITEM:
			use_item(equipped_item)

	if Input.is_action_just_pressed("a"):
			throw_boomerang()
	if Input.is_action_just_pressed("b"):
			state = ATTACK
	if Input.is_action_just_pressed("x"):
			fire_arrow()
			
func idle(delta):
	animation_state.travel("Idle")
	if velocity != Vector2.ZERO:
		state = WALK
	
func walk(delta):
	animation_state.travel("Walk")
	move_and_slide((velocity.normalized() * speed) + hit_knockback)
	if velocity == Vector2.ZERO:
		state = IDLE
	
func attack(delta):
	animation_state.travel("Attack")
			
func use_item(item):
	pass

func throw_boomerang():
	if can_throw_boomerang:
		var boomerang = Boomerang.instance()
		boomerang.player = $"."
		boomerang.start_direction = direction
		boomerang.position = global_position + (direction * 32)
		get_tree().root.add_child(boomerang)
		can_throw_boomerang = false
		
func fire_arrow():
	if can_fire_arrow:
		var arrow = Arrow.instance()
		arrow.position = global_position + direction * 32
#		arrow.apply_central_impulse(direction * arrow.speed)
		arrow.start_direction = direction
#		arrow.get_node("HitBox").direction = direction
#		arrow.rotate(global_position.angle_to(direction))
		get_tree().root.add_child(arrow)


func _on_HurtBox_area_entered(area):
	hit_knockback = area.direction * area.knockback
	health -= area.damage
	if health <= 0:
		queue_free()
	hurt_box.get_node("CollisionShape2D").set_deferred("monitorable", false)
	yield(get_tree().create_timer(invincibility_time), "timeout")
	hurt_box.get_node("CollisionShape2D").set_deferred("monitorable", true)
		
func attack_animation_finished():
	state = IDLE
