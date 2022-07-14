## The base class for an enemy
## Contains the general logic that most basic enemy types will follow
## Not necessarily to be used for more complex enemy types other than for the stat variables
class_name Enemy
extends Creature

## The states that the enemy can be in. These are the default states, more can be added for individual enemies
var states = {
	"IDLE" : 0,
	"CHASE" : 1,
	"WANDER" : 2,
	"STUNNED" : 3,
	"DEAD" : 4
	}
onready var IDLE = states.get("IDLE")
onready var CHASE = states.get("CHASE")
onready var WANDER = states.get("WANDER")
onready var STUNNED = states.get("STUNNED")
onready var DEAD = states.get("DEAD")

## The current state the enemy is in. Will influence enemy behavior
var state : int setget change_state, get_state
onready var detection_area = $DetectionArea
onready var hitbox = $HitBox
onready var hurtbox = $HurtBox
onready var animated_sprite = $AnimatedSprite
onready var stun_timer = $StunTimer
onready var wander_timer = $WanderTimer
## The starting position of the enemy, to be used in the wander state to ensure movement is not to far
onready var start_position = global_position
onready var Death_Effect = preload("res://SpecialEffects/DeathEffect.tscn")

## The maximum health the enemy can have
export var max_health := 5
## The current total health points of the enemy
onready var health := max_health setget set_health
## The player, this field should only have a value if the player is in the enemy's detection zone, else it should be set to null
var player
## Wheather the enemy is dead or not, limits certain function calls if true
var dead := false
## Whether the enemy is stunned or not
var stunned := false

## The maximum speed the enemy will move
export var max_speed := 75
## The speed the enemy will move when chasing the player
export var chase_max_speed := 150
## The rate at which the enemy will speed up when moving
export var acceleration := 300 
## The rate at which the enemy will slow down when stopping
export var friction := 600 
## The amount of damage the enemy will do when it collides with the player
export var damage := 10
## The degree to which the enemy will knock back those it collides with
export var knockback := 0
## Whether or not the enemy stuns those it collides with
export var stuns := false
## The maximum distance the enemy can wander in its wander state from the position it starts in
export var max_wander_distance := 500
## Whether or not the enemy takes knockback when hit
export var takes_knockback := true
## The next direction in which the enemy will wander
onready var next_direction := Vector2.ZERO

signal state_changed(next_state)

func _ready():
	if not is_in_group("Enemies"):
		add_to_group("Enemies")
	if detection_area != null:
		detection_area.connect("body_entered", self, "_on_DetectionArea_body_entered")
		detection_area.connect("body_exited", self, "_on_DetectionArea_body_exited")
	if hurtbox != null:
		hurtbox.connect("area_entered", self, "take_hit")
	if stun_timer != null:
		stun_timer.connect("timeout", self, "exit_stunned")
#	if invincibility_timer != null:
#		invincibility_timer.connect("timeout", self, "_on_InvincibilityTimer_timeout")
	if animated_sprite != null:
		animated_sprite.connect("animation_finished", self, "vanish")
	if wander_timer != null:
		wander_timer.connect("timeout", self, "change_direction")
	if hitbox != null:
		hitbox.damage = damage
		hitbox.knockback = knockback
		hitbox.stuns = stuns
	
	connect("state_changed", self, "state_changed")
	connect("tree_exiting", self, "spawn_death_effect")
	randomize()

## The logic for taking a hit
## @Override
func take_hit(area):
	if not stunned:
		if area.stuns:
			enter_stunned()
		if takes_knockback:
			velocity = area.direction * area.knockback
	hurtbox.start_invincibility(invincibility_duration)
	self.health -= area.damage
#	take_damage_audio.play()
	if health <= 0:
		die()

## For when the enemy is stunned
## Puts the enemy in the "stunned" state and starts the timer to exit the stunned state
## @Override
func enter_stunned():
	change_state(STUNNED)
	detection_area.set_deferred("monitoring", false)
	animated_sprite.stop()
	if stun_timer != null:
		if stun_timer.is_stopped():
			stun_timer.start()
#
## Exits the stunned state and returns the enemy to normal behavior logic
func exit_stunned():
	if get_state() == STUNNED:
		detection_area.set_deferred("monitoring", true)
		change_state(IDLE)
#
## Setter for health
## Determines if the enemy is dead or not and if so, sets the state to "dead"
func set_health(current_health):
	health = current_health 
	if health <= 0:
		die()
#
## Virtual function
## Registers detection of the player and sets the 'player' var to the player
## @Override
func _on_DetectionArea_body_entered(_body):
	player = _body
#
## Virtual function
## Registers the player leaving the search range and sets the player to null
## @Override
func _on_DetectionArea_body_exited(_body):
	player = null
#
## Virtual function
## Controls what happens when the player dies
## Called when health drops to 0
## @Override
func die():
	dead = true
	detection_area.set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false)
	change_state(DEAD)

## Called when the enemy dies
## Contains the logic for how the enemy will dissapear/deload upon death
## @Override
func vanish():
	if get_state() == DEAD or dead:
		queue_free()

## Virtual function
##Contains the logic for when an enmy hits the player
## Called by the body that is hit
## @Override
func give_hit():
	velocity *= - 1
	
## Virtual Function
## Changes the direction the enemy's wander state will travel in
## Called when the 'WanderTimer' node sends the timeout signal
func change_direction():
	pass
	
## Changes the enemy's current state to new_state
## @Param new_state: an enumeration of the new state to be transitioned to
func change_state(new_state : int):
	state = new_state
	emit_signal("state_changed", new_state)
	
## Virtual function
## Called through "state_changed" signal when emitted
## Handles logic for state changes
## @Override
func state_changed(_new_state):
	pass
	
func get_state():
	return state
	
func add_state(state_name : String):
	var last_state := 0
	for i in states:
		if states.get(i) > last_state:
			last_state = states.get(i)
	states[state_name] = last_state + 1
	
func spawn_death_effect(_death_effect : AnimatedSprite = Death_Effect):
	var death_effect: AnimatedSprite = _death_effect.instance()
	death_effect.global_position = global_position
	death_effect.frame = 0
	death_effect.play()
	death_effect.connect("animation_finished", death_effect, "queue_free")
	get_tree().current_scene.call_deferred("add_child", death_effect) #add_child(death_effect)
