extends Area2D

@export var sprite: Texture
@export var required_key: String = ""
@export var special_item: String = ""
@export var onesideddoor: bool = false
@export var accessible_side: String = ""
@onready var door_sfx = $DoorSFX
@onready var door_locked = $DoorLocked

var character
func _ready():
	$Sprite2D.texture = sprite
	character = get_node("/root/Level/Character")

func activate(player):

	var blocked := false

	if onesideddoor and !is_approaching_from_correct_side(player):
		Global.log("You cannot open this door from this side!")
		blocked = true

	if required_key != "" and !player.has_item(required_key):
		Global.log("Door is locked. Missing key: " + required_key)
		blocked = true

	if special_item != "" and !player.has_item(special_item):
		Global.log("Door needs a special item: " + special_item)
		blocked = true

	if blocked:
		door_locked.play()
		return
	
	door_sfx.play()

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
		Global1.log("Turns: " + str(GlobalLevel.Turns))
	$StaticBody2D/CollisionShape2D.disabled = true
	$".".visible = false
	$".".monitoring = false
	$".".monitorable = false
func _process(_delta):
	if character.Is_going_back == true:
		$StaticBody2D/CollisionShape2D.disabled = false

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
