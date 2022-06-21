class_name Creature
extends KinematicBody2D

var direction := Vector2.DOWN
var velocity := Vector2.ZERO
#onready var hurtbox = $HurtBox
#onready var stats = $Stats
onready var softcollisionbox = $SoftCollisionBox
## The degree to which a soft collision pushes the creature back
export var soft_collision_magnitude := 3000
## The length of time in seconds that the creature will be invincible after taking damage
export var invincibility_duration := 0.5

func _ready():
#	if hurtbox != null:
#		hurtbox.connect("area_entered", self, "take_hit")
	pass
	
func _physics_process(delta):
	if softcollisionbox != null:
		if softcollisionbox.is_colliding():
			velocity = softcollisionbox.get_push_vector() * soft_collision_magnitude * delta
	
		
func take_hit(_area):
	pass

#Use the state machine to handle properties like "stunnable, etc. That way if the creature type does not have it, it simply will not be called (use duck typing) and handle the transitions within the other states

###This function sets the state to stunned (should actually be included in the state machine)
#func enter_stunned(duration):
#	if stats.stunnable:
#		pass
#		#change the state machine state to stunned 
#			#the stunned state move velocity towards zero and stop the animation/change the animation to stunned/idle/frozen
#		#start the stun timer with time @param duration
#
#func exit_stunned():
#	pass
#	#called when the stun timer ends and switches the state back to idle or other


