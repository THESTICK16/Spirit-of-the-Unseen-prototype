extends YSort

## The signal emitted when all enemies have been defeated
signal all_enemies_defeated

## The sound effect to be played when all enemies under this node have been defeated
export var sound_effect : AudioStream

## The number of enemies currently left before the lock releases
onready var num_enemies_remaining : int = get_child_count()

func _ready():
	for enemy in get_children():
		if not enemy is Enemy:
			push_error("Only nodes of type 'Enemy' can be children of this node")
			enemy.queue_free()
		else:
			enemy.connect("tree_exited", self, "on_enemy_defeated")

func on_enemy_defeated():
	num_enemies_remaining = get_child_count()
	if num_enemies_remaining < 1:
		emit_signal("all_enemies_defeated")
		if sound_effect != null:
			SFXController.play_sfx(sound_effect)
		queue_free()
