extends Area2D

var required_item: String = "gear"
var increase_amount: int = 3
@onready var gear = $Gear
@onready var no_gear = $NoGear

func SnapMachineToGrid():
	var tile_size = $"../Grid".tile_set.tile_size.x
	position = position.snapped(Vector2.ONE * tile_size) + Vector2.ONE * tile_size / 2

func _ready():
	SnapMachineToGrid()

func activate(player):
	if player.has_item(required_item):
		player.remove_item(required_item)
		GlobalLevel.TurnsMax += increase_amount
		Global.log("Gear used! Max Turns increased to " + str(GlobalLevel.TurnsMax))
		gear.play()
	else:
		Global.log("You need a gear to use this machine.")
		no_gear.play()
