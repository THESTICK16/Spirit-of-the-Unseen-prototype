extends AudioStreamPlayer

var _queued_sounds = []

func _ready():
	connect("finished", self, "_check_for_next_sound")

func play_sfx(sfx : AudioStream):
	if sfx is AudioStream:
		if playing:
			_queued_sounds.push_front(sfx)
			return
		else:
			stream = sfx
		
	if stream != null:
		play()
		yield(self, "finished")
		stream = null
		
	else:
		print("Failed to play Audio. No AudioStream detected.")
		
func _check_for_next_sound():
	if _queued_sounds.size() > 0:
		play_sfx(_queued_sounds.pop_back())
