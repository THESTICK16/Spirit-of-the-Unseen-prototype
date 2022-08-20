extends AudioStreamPlayer

func play_music(music : AudioStream, decibels := 0.0):
	self.volume_db = decibels
	if music is AudioStream:
		stream = music
		
	if stream != null:
		play()
		yield(self, "finished")
#		stream = null
		
	else:
		print("Failed to play Audio. No AudioStream detected.")
	self.volume_db = 0.0

func stop_music():
	stop()
	
func is_playing():
	return playing

func get_current_music():
	return stream
