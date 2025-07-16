extends Area2D

@export var required_key: String
@export var special_item: String
@export var reward_item: String = "gear"
@export var sprite: Texture

func SnapBoxToGrid():
	var tile_size = $"../Grid".tile_set.tile_size.x
	position = position.snapped(Vector2.ONE * tile_size) + Vector2.ONE * tile_size / 2
	
func _ready():
	SnapBoxToGrid()
	$Sprite2D.texture = sprite

func activate(player):

	if required_key != "" and !player.has_item(required_key):
		Global.log("Box is locked. Missing key: " + required_key)
		return

	if special_item != "" and !player.has_item(special_item):
		Global.log("Box needs a special item: " + special_item)
		return

	if required_key != "":
		player.remove_item(required_key)
		GlobalLevel.Turns += 1
	if special_item != "":
		GlobalLevel.Turns += 1
		player.remove_item(special_item)

	if player.has_method("add_item"):
		player.add_item(reward_item)
		Global.log("Opened a box")
		if reward_item == "gear":
			reward_item = ""
		print("Turns: ", GlobalLevel.Turns)
	$".".visible = false
	$".".monitoring = false
	$".".monitorable = false
