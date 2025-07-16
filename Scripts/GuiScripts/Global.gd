extends Node

var hud = null

func log(message: String):
	if hud:
		hud.log_message(message)
	else:
		print(message)
