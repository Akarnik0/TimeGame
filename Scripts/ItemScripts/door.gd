extends Area2D

@export var sprite: Texture
@export var required_key: String = ""
@export var special_item: String = ""
@export var onesideddoor: bool = false
@export var accessible_side: String = ""
var opened = false

func _ready():
	$Sprite2D.texture = sprite

func activate(player):
	if opened:
		return

	var blocked := false

	if onesideddoor and !is_approaching_from_correct_side(player):
		print("You cannot open this door from this side!")
		blocked = true

	if required_key != "" and !player.has_item(required_key):
		print("Door is locked. Missing key: ", required_key)
		blocked = true

	if special_item != "" and !player.has_item(special_item):
		print("Door needs a special item: ", special_item)
		blocked = true

	if blocked:
		return

	if required_key != "":
		player.remove_item(required_key)
	if special_item != "":
		player.remove_item(special_item)

	var used_items = []
	if required_key != "":
		used_items.append(required_key)
	if special_item != "":
		used_items.append(special_item)
		GlobalLevel.Turns += 1
		print("Turns: ", GlobalLevel.Turns)

	queue_free()

func is_approaching_from_correct_side(player) -> bool:
	var door_position = position
	var player_position = player.position

	if accessible_side == "right" and player_position.x > door_position.x:
		return true
	elif accessible_side == "left" and player_position.x < door_position.x:
		return true
	elif accessible_side == "top" and player_position.y < door_position.y:
		return true
	elif accessible_side == "bottom" and player_position.y > door_position.y:
		return true
	return false
