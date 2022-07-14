extends Area2D

onready var invincibility_timer = $InvincibilityTimer
onready var take_damage_audio = $TakeDamageAudioStreamPlayer
## Whether the owner of the hurtbox can take damage
var invincible := false #setget set_invincible

func _ready():
	invincibility_timer.connect("timeout", self, "end_invincibility")
	self.connect("area_entered", self, "play_damage_audio")

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
	
func play_damage_audio(_area):
	if _area.get("damage") != null:
		if _area.damage > 0:
			take_damage_audio.play()
