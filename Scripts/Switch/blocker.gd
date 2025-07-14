extends StaticBody2D

func _ready():
	$MessageArea.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Character":
		print("You can't enter a dark room!")
