extends Node

var hud1 = null

func log(potezi: String):
	if hud1:
		hud1.log_message1(potezi)
	else:
		print(potezi)
