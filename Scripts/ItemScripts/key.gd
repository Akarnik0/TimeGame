extends Area2D

@export var item_name: String
@export var sprite_texture: Texture

func SnapKeyToGrid():
	var tile_size = $"../Grid".tile_set.tile_size.x
	position = position.snapped(Vector2.ONE * tile_size) + Vector2.ONE * tile_size / 2

func _ready():
	$Sprite2D.texture = sprite_texture
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	SnapKeyToGrid()

func _on_body_entered(body):
	if body.has_method("add_item"):
		body.add_item(item_name)
		queue_free()
