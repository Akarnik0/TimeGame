extends Area2D

@export var item_name: String
@export var sprite_texture: Texture

func _ready():
	$Sprite2D.texture = sprite_texture
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.has_method("add_item"):
		body.add_item(item_name)
		queue_free()
