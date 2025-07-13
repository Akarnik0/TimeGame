extends Camera2D

#za pristup CharacterMovement skripti karaktera
var player
#za provjerivanje stanja kamere
var Is_on_character: bool

func Get_level_center():
	var rect: Rect2i = $"../Grid".get_used_rect()
	var center_tile: Vector2i = rect.position + rect.size / 2
	var center_local: Vector2 = $"../Grid".map_to_local(center_tile)
	return center_local
#pomjeri kameru u centar mape
func Move_camera_to_center(center: Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property($".", "zoom", Vector2(1, 1), 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($".", "global_position", Vector2(center), 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	tween.chain().tween_callback(Callable(self, "_on_move_to_center"))
func _on_move_to_center():
	Is_on_character = false
#pomjeri kameru na karaktera
func Move_camera_to_character(character: Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property($".", "global_position", Vector2(character), 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($".", "zoom", Vector2(3, 3), 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	tween.chain().tween_callback(Callable(self, "_on_move_to_character"))
func _on_move_to_character():
	Is_on_character = true
func _ready():
	player = get_node("/root/Level/Character")
	Is_on_character = true
func _process(_delta):
	if Is_on_character == true:
		position = player.position
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("show_map") && Is_on_character == true:
		Move_camera_to_center(Get_level_center())
	elif event.is_action_pressed("show_map") && Is_on_character == false:
		Move_camera_to_character(player.position)
