extends AudioStreamPlayer

const menu_music = preload("res://SFX/Music/MenuTheme.wav")
const game_music = preload("res://SFX/Music/ThemeComplete.mp3")

func _play_music(music: AudioStream, volume = -10.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

func play_music_menu():
	_play_music(menu_music)
	
func play_music_game():
	_play_music(game_music)
