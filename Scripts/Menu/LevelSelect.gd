extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")
	
func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/Level/level.tscn")
