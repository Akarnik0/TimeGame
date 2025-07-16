extends CanvasLayer

var player

func _ready():
	player = get_node("/root/Level/Character")
	Global.hud = self

func _process(_delta):
	if player:
		$InventoryItems.text = player.GetInventoryItems()

@onready var message_log_label = $MessageLog
const MAX_MESSAGES = 3
var messages: Array[String] = []

func log_message(new_message: String):
	messages.append(new_message)

	if messages.size() > MAX_MESSAGES:
		messages.pop_front()

	message_log_label.text = "\n".join(messages)
