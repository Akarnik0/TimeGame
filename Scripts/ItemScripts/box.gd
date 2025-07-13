extends Area2D

@export var required_key: String
@export var reward_item: String = "gear"
@export var sprite: Texture
var opened = false

func SnapBoxToGrid():
	var tile_size = $"../Grid".tile_set.tile_size.x
	position = position.snapped(Vector2.ONE * tile_size) + Vector2.ONE * tile_size / 2

func _ready():
	$Sprite2D.texture = sprite
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	SnapBoxToGrid()
	
func _on_body_entered(body):
	if opened:
		return

	if body.has_method("has_item") and body.has_item(required_key):
		opened = true

		if body.has_method("add_item"):
			body.add_item(reward_item)
			queue_free()
	else:
		print("Box is locked. Requires: ", required_key)
