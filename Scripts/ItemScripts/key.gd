extends Area2D

@export var item_name: String
@export var sprite_texture: Texture
var character

func SnapKeyToGrid():
	var tile_size = $"../Grid".tile_set.tile_size.x
	position = position.snapped(Vector2.ONE * tile_size) + Vector2.ONE * tile_size / 2

func _ready():
	$Sprite2D.texture = sprite_texture
	SnapKeyToGrid()
	character = get_node("/root/Level/Character")

func activate(player):
	if player.has_method("add_item"):
		player.add_item(item_name)
		Global.log("Piced up a key")
		visible = false
		monitoring = false
		monitorable = false
