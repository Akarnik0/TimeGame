extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/LevelSelect.tscn")

func _on_how_to_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/HowToPlay.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/Credits.tscn")

func _on_quit_pressed():
	get_tree().quit()
