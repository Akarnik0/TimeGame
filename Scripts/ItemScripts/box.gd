extends Area2D

@export var required_key: String
@export var special_item: String
@export var reward_item: String = "gear"
@onready var box_sfx = $BoxSFX
@export var sprite: Texture

func SnapBoxToGrid():
	var tile_size = $"../Grid".tile_set.tile_size.x
	position = position.snapped(Vector2.ONE * tile_size) + Vector2.ONE * tile_size / 2
	
func _ready():
	SnapBoxToGrid()
	$Sprite2D.texture = sprite

func activate(player):

	var missing = false

	if required_key != "" and !player.has_item(required_key):
		Global.log("Box is locked. Missing key: " + required_key)
		missing = true

	if special_item != "" and !player.has_item(special_item):
		Global.log("Box needs a special item: " + special_item)
		missing = true

	if missing:
		return

	if required_key != "":
		player.remove_item(required_key)
	if special_item != "":
		GlobalLevel.Turns += 1
		player.remove_item(special_item)

	if player.has_method("add_item"):
		player.add_item(reward_item)
		Global.log("Opened a box")
		GlobalLevel.Turns += 1
		box_sfx.play()
		if reward_item == "gear":
			reward_item = ""
		Global1.log("Turns: " + str(GlobalLevel.Turns))
	$".".visible = false
	$".".monitoring = false
	$".".monitorable = false
