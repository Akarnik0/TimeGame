extends Area2D

@export var sprite: Texture
@export var blocker_path: NodePath
@onready var flip_sfx = $FlipSFX

var used = false

var is_light_switch = true

func SnapSwitchToGrid():
	var tile_size = $"../Grid".tile_set.tile_size.x
	position = position.snapped(Vector2.ONE * tile_size) + Vector2.ONE * tile_size / 2

func _ready():
	$Sprite2D.texture = sprite
	SnapSwitchToGrid()
	

func activate(_player):
	
	if used:
		Global.log("This switch can’t be used again.")
		return
	flip_sfx.play()
	
	var blocker = get_node(blocker_path)

	if blocker: 
		blocker.get_child(0).visible = false
		blocker.get_child(1).disabled = true
		blocker.get_child(2).monitoring = false
		blocker.get_child(2).monitorable = false
		GlobalLevel.Turns += 1
		Global1.log("Turns: " + str(GlobalLevel.Turns))
		Global.log("Light are now ON")
		used = true
