extends CanvasLayer

var player

func _ready():
	player = get_node("/root/Level/Character")

func _process(_delta):
	if player:
		$InventoryItems.text = player.GetInventoryItems()
