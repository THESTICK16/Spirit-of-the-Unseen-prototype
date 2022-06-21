extends Area2D

export (Resource) var weapon
var teleportee

func _ready():
	pass #Connect signals to nodes here

func _on_DespawnTimer_timeout():
	queue_free()


func _on_RotateAttack_body_entered(body):
	teleport_victim(body)
#	teleportee = body
#	var offset_x = rand_range(-250, 250)
#	var offset_y = rand_range(-250, 250)
#	teleportee.global_position += Vector2(offset_x, offset_y)
	
func teleport_victim(victim):
	var offset = Vector2.ZERO
	offset.x = rand_range(-250, 250)
	offset.y = rand_range(-250, 250)
	victim.global_position += offset
	
	#if victim.global_position [is overlapping something else]:
		#teleport_victim(victim)
