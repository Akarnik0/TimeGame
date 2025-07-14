extends Area2D

@export var sprite: Texture
@export var blocker_path: NodePath

var used = false

func SnapSwitchToGrid():
	var tile_size = $"../Grid".tile_set.tile_size.x
	position = position.snapped(Vector2.ONE * tile_size) + Vector2.ONE * tile_size / 2

func _ready():
	$Sprite2D.texture = sprite
	SnapSwitchToGrid()
	

func activate(_player):
	
	if used:
		print("This switch can’t be used again.")
		return
	
	var blocker = get_node(blocker_path)

	if blocker: 
		blocker.queue_free()
		GlobalLevel.Turns += 1
		print("Turns: ", GlobalLevel.Turns)
		print("Light are now ON")
		used = true
