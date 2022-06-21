extends Area2D

var player_stats = PlayerStats

## The name of the stat to be refilled
export var refill_stat_name : String
## The amount by which the stat will be refilled
export var refill_amount := 1

func _ready():
	connect("area_entered", self, "acquire")
#	refill_stat()

func refill_stat():
	if player_stats.get(refill_stat_name) != null:
		var stat : int = player_stats.get(refill_stat_name)
		player_stats.set(refill_stat_name, stat + refill_amount)
		
func acquire(body):
	refill_stat()
	queue_free()
