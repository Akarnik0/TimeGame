extends CharacterBody2D

const Speed: int = 200
#moguci unosi
var Inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}
#snapuje lika na jedno od polja
func SnapCharacterToGrid():
	position = position.snapped(Vector2.ONE * $"../Grid".tile_set.tile_size.x) + Vector2.ONE * $"../Grid".tile_set.tile_size.x / 2
func Move(Direction):
	var TargetPosition = position + Inputs[Direction] * $"../Grid".tile_set.tile_size.x
	position = TargetPosition
#pokrece se jednom kada se upali skripta
func _ready():
	SnapCharacterToGrid()
##kada se pritisne dugme, provjerava da li je neko od dugmica za kretanje pritisnuto
##ako jeste, pozove se metoda move koja pomjera karaktera na to polje
func _unhandled_input(event: InputEvent):
	for Direction in Inputs.keys():
		if event.is_action_pressed(Direction):
			Move(Direction)
