extends Node

var LevelName: String
var Turns: int = 0
var TurnsMax: int = 3

func _ready():
	LevelName = "Level1"
	Audio.play_music_game()

var has_won := false

func _process(_delta):
	if TurnsMax >= 13 and not has_won:
		has_won = true
		get_tree().change_scene_to_file("res://Scenes/Level/VictoryScreen.tscn")
