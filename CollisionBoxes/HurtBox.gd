extends Area2D

onready var invincibility_timer = $InvincibilityTimer
## Whether the owner of the hurtbox can take damage
var invincible := false #setget set_invincible

func _ready():
	invincibility_timer.connect("timeout", self, "end_invincibility")

func set_invincible(value : bool):
	if value:
		start_invincibility(0.15)
	else:
		end_invincibility()
	
func start_invincibility(duration : float):
	self.invincible = true
	invincibility_timer.start(duration)
	set_deferred("monitoring", false)
	
func end_invincibility():
	self.invincible = false
	set_deferred("monitoring", true)
