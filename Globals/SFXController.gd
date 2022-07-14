extends AudioStreamPlayer

var _queued_sounds = []

const eyes_enabled_sound = preload("res://Assets/Sound/SoundFX/UI pack 1/MENU A_Select.wav")
const eyes_disabled_sound = preload("res://Assets/Sound/SoundFX/UI pack 1/MENU A - Back.wav")

func _ready():
	connect("finished", self, "_check_for_next_sound")

func play_sfx(sfx : AudioStream, queue_if_busy := true, decibels := 0.0, interrupt := false):
	self.volume_db = decibels
	if sfx is AudioStream:
		if playing and not interrupt:
			if queue_if_busy:
				_queued_sounds.push_front({"sfx" : sfx, "decibels" : decibels})
			return
		else:
			stream = sfx
		
	if stream != null:
		play()
		yield(self, "finished")
#		stream = null
		
	else:
		print("Failed to play Audio. No AudioStream detected.")
	self.volume_db = 0.0
		
func _check_for_next_sound():
	if _queued_sounds.size() > 0:
		var next_sound_dict : Dictionary = _queued_sounds.pop_back()
		self.play_sfx(next_sound_dict.get("sfx"), true, next_sound_dict.get("decibels"))
#		play_sfx(_queued_sounds.pop_back())
	else:
		stream = null
