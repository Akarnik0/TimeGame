extends CharacterBody2D

const Speed: int = 200
@onready var ray = $RayCast2D  # Make sure this RayCast2D node exists in the scene

# Directional inputs
var Inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

# Snap character to grid center
func SnapCharacterToGrid():
	var tile_size = $"../Grid".tile_set.tile_size.x
	position = position.snapped(Vector2.ONE * tile_size) + Vector2.ONE * tile_size / 2

# Movement with collision check via RayCast2D
func Move(Direction):
	var tile_size = $"../Grid".tile_set.tile_size.x
	ray.target_position = Inputs[Direction] * tile_size  # Aim ray in direction of movement
	ray.force_raycast_update()

	if !ray.is_colliding():
		position += Inputs[Direction] * tile_size

# Called once when the scene is ready
func _ready():
	SnapCharacterToGrid()

# Handle input (arrow keys or WASD, if mapped in project settings)
func _unhandled_input(event: InputEvent):
	for Direction in Inputs.keys():
		if event.is_action_pressed(Direction):
			Move(Direction)
