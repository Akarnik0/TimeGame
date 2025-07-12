extends CharacterBody2D
#varijabla u kojoj ce se cuvaju podaci o lokacijama svih vrata unutar jsona
var AllDoors = {}
#varijabla u kojoj se cuvaju podaci o lokacijama vrata u levelu unutar jsona
var Doors
@onready var ray = $RayCast2D  # Make sure this RayCast2D node exists in the scene

var IsInDoor: bool
var SameRoomPosition

# Directional inputs
var Inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}
#Dobije podatke o lokaciji svih vrata unutar jsona
func GetDoorData(FilePath: String):
	var File = FileAccess.open(FilePath, FileAccess.READ)
	var JsonText = File.get_as_text()
	var ResultText = JSON.parse_string(JsonText)
	AllDoors = ResultText
#Dobije podatke o lokaciji vrata iz levela unutar jsona
func GetDoorDataForLevel(LevelName: String):
	var RawArray = AllDoors.get(LevelName,[])
	var LevelDoors = []
	for Pair in RawArray:
		if Pair.size() == 2:
			LevelDoors.append(Vector2(Pair[0], Pair[1]))
	return LevelDoors
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
		var LastPosition = position
		if position != SameRoomPosition && IsInDoor == true:
			GlobalLevel.Turns += 1
			print(GlobalLevel.Turns)
			if GlobalLevel.Turns >=12:
				print("gotovo")
			IsInDoor = false
		else:
			IsInDoor = false
		for i in Doors:
			if position == i:
				IsInDoor = true
				SameRoomPosition = LastPosition

# Called once when the scene is ready
func _ready():
	SnapCharacterToGrid()
	GetDoorData("res://JSON/DoorLocations.json")
	Doors = GetDoorDataForLevel(GlobalLevel.LevelName)

# Handle input (arrow keys or WASD, if mapped in project settings)
func _unhandled_input(event: InputEvent):
	for Direction in Inputs.keys():
		if event.is_action_pressed(Direction):
			Move(Direction)
