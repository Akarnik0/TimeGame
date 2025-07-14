extends Area2D

@export var sprite: Texture
@export var blocker_path: NodePath
@export var overlay_path: NodePath

var used = false

func _ready():
	$Sprite2D.texture = sprite

func activate(_player):
	
	if used:
		print("This switch can’t be used again.")
		return
	
	var blocker = get_node(blocker_path)
	var overlay = get_node(overlay_path)

	if blocker: 
		blocker.queue_free()
		GlobalLevel.Turns += 1
		print("Turns: ", GlobalLevel.Turns)
		used = true

	if overlay: 
		overlay.hide()
