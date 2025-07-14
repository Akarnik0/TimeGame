extends Area2D

#Ne radi kako treba za sad samo placeholder

@export var sprite: Texture

@export var light_blocker_path: NodePath
@export var light_overlay_path: NodePath   

@export var dark_blocker_path: NodePath      
@export var dark_overlay_path: NodePath      

var lights_on = false

func _ready():
	$Sprite2D.texture = sprite

func activate(_player):
	lights_on = !lights_on
	print("Lights on:", lights_on)

	var light_blocker = get_node_or_null(light_blocker_path)
	var light_overlay = get_node_or_null(light_overlay_path)

	var dark_blocker = get_node_or_null(dark_blocker_path)
	var dark_overlay = get_node_or_null(dark_overlay_path)

	if lights_on:
		if light_blocker: light_blocker.queue_free()
		if light_overlay: light_overlay.hide()

		if dark_blocker and !dark_blocker.is_inside_tree():
			get_parent().add_child(dark_blocker)
		if dark_overlay: dark_overlay.show()

	else:
		if dark_blocker: dark_blocker.queue_free()
		if dark_overlay: dark_overlay.hide()

		if light_blocker and !light_blocker.is_inside_tree():
			get_parent().add_child(light_blocker)
		if light_overlay: light_overlay.show()
