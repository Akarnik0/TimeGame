extends CharacterBody2D
#varijabla u kojoj ce se cuvaju podaci o lokacijama svih vrata unutar jsona
var AllDoors = {}
#varijabla u kojoj se cuvaju podaci o lokacijama vrata u levelu unutar jsona
var Doors
@onready var ray = $RayCast2D  # Make sure this RayCast2D node exists in the scene
@onready var move_sfx = $MoveSFX


var IsInDoor: bool
var SameRoomPosition

#kretanje
# Directional inputs
var Inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}
#svi koraci koje je obavio karakter
var Character_movements: Array[Vector2] = []
#pravac u kojem je gledao dok je se kretao
var Character_looks: Array[String] = []
#SEKCIJA TESTIRANJA
#---------------------------------------------------------------------------
class Character_interactions:
	#kada se dodaje nesto na njega jednak je zadnjem clanu Character_movements
	var Interaction_turn_number: Array[int]
	var Interaction_item: Array[Area2D]
var is_interacting = false
var Character_interact = Character_interactions.new()
#---------------------------------------------------------------------------
#timer za vracanje unazad,varijabla za provjeru vracanja unazad,broj clana niza
var Is_going_back = false
var Going_back_id = 0
var Going_back_timer := Timer.new()
func Start_going_back():
	if Character_movements.size() > 1:
		Is_going_back = true
		Going_back_id = Character_movements.size() - 1
		Going_back_timer.start()
func _On_go_back_step():
	if Going_back_id >= 0:
		position = Character_movements[Going_back_id]
		change_sprite(Character_looks[Going_back_id])
		#SEKCIJA TESTIRANJA
		#---------------------------------------------------------------------------
		for turn_number in range(Character_interact.Interaction_turn_number.size()):
			if Character_interact.Interaction_turn_number[turn_number] == Going_back_id:
				print("Trying to access interaction item at turn", turn_number, ":", Character_interact.Interaction_item[turn_number])
				is_interacting = true
				Character_interact.Interaction_item[turn_number].visible = true
				Character_interact.Interaction_item[turn_number].monitorable = true
				Character_interact.Interaction_item[turn_number].monitoring = true
				#ovo je uzasan kod, nemam vremena da ni snage da napisem ovo na lijepsi nacin
				if "is_light_switch" in Character_interact.Interaction_item[turn_number]:
					var blocker = Character_interact.Interaction_item[turn_number].get_node(Character_interact.Interaction_item[turn_number].blocker_path)
					blocker.get_child(0).visible = true
					blocker.get_child(1).disabled = false
					blocker.get_child(2).monitoring = true
					blocker.get_child(2).monitorable = true
					Character_interact.Interaction_item[turn_number].used = false
		#---------------------------------------------------------------------------
		if(Going_back_timer.wait_time >= 0.05):
			Going_back_timer.wait_time -= 0.01
		Going_back_id -= 1
	else:
		Going_back_timer.stop()
		#SEKCIJA TESTIRANJA
		#---------------------------------------------------------------------------
		Character_interact.Interaction_turn_number.clear()
		Character_interact.Interaction_item.clear()
		#---------------------------------------------------------------------------
		Character_movements.clear()
		Character_movements.append(first_position)
		Character_looks.clear()
		Character_looks.append(first_looks)
		GlobalLevel.Turns = 0
		Going_back_timer.wait_time = 0.2
		for item in inventory.duplicate():
			if item != "gear":
				inventory.erase(item)
		Is_going_back = false
var first_position
var first_looks
# Snap character to grid center
func SnapCharacterToGrid():
	var tile_size = $"../Grid".tile_set.tile_size.x
	position = position.snapped(Vector2.ONE * tile_size) + Vector2.ONE * tile_size / 2
	Character_looks.append("down")
	first_looks = "down"
	Character_movements.append(position)
	first_position = position

# Movement with collision check via RayCast2D
func Move(Direction):
	var tile_size = $"../Grid".tile_set.tile_size.x
	ray.target_position = Inputs[Direction] * tile_size  # Aim ray in direction of movement
	ray.force_raycast_update()
	#postavlja lokaciju interact collisiona jedno polje ispred smjera kretanja karaktera
	$InteractArea/CollisionShape2D.position = Inputs[Direction] * tile_size
	if !ray.is_colliding():
		var LastPosition = position
		position += Inputs[Direction] * tile_size
		move_sfx.play()
		Character_movements.append(position)
		Character_looks.append(Direction)
		if position != SameRoomPosition && IsInDoor == true:
			GlobalLevel.Turns += 1
			print("Turns: ",GlobalLevel.Turns)
			IsInDoor = false
		else:
			IsInDoor = false
		for i in Doors:
			if position == i:
				IsInDoor = true
				SameRoomPosition = LastPosition

func _process(_delta):
	if GlobalLevel.Turns == GlobalLevel.TurnsMax && Is_going_back == false:
		Global.log("You reached the max number of turns!")
		print("gotovo")
		Start_going_back()
	else:
		return
		

# Called once when the scene is ready
func _ready():
	SnapCharacterToGrid()
	GetDoorData("res://JSON/DoorLocations.json")
	Doors = GetDoorDataForLevel(GlobalLevel.LevelName)
	
	$InteractArea.connect("area_entered", Callable(self, "_on_InteractArea_area_entered"))
	$InteractArea.connect("area_exited", Callable(self, "_on_InteractArea_area_exited"))
	#timer za kada se bude vracalo vrijeme unazad
	Going_back_timer.wait_time = 0.2
	Going_back_timer.one_shot = false
	Going_back_timer.connect("timeout", Callable(self, "_On_go_back_step"))
	add_child(Going_back_timer)

func change_sprite(dir:String):
	match dir:
		"right":
			$Sprite2D.texture = load("res://Assets/CharacterAssets/LikE.webp")
		"left":
			$Sprite2D.texture = load("res://Assets/CharacterAssets/LikW.webp")
		"up":
			$Sprite2D.texture = load("res://Assets/CharacterAssets/LikN.webp")
		"down":
			$Sprite2D.texture = load("res://Assets/CharacterAssets/LikS.webp")

# Handle input (arrow keys or WASD, if mapped in project settings)
func _unhandled_input(event: InputEvent):
	#sprijecava da se nesto unese dok se vraca vrijeme
	if Is_going_back:
		return
	else:
		for Direction in Inputs.keys():
			if event.is_action_pressed(Direction):
				change_sprite(Direction)
				Move(Direction)
		if event.is_action_pressed("interact"):
			for obj in interactables:
				if obj.has_method("activate") && obj.visible == true:
					#SEKCIJA TESTIRANJA
					#---------------------------------------------------------------------------
					Character_interact.Interaction_turn_number.append(Character_movements.size()-1)
					Character_interact.Interaction_item.append(obj)
					print("Storing interaction item:", obj, " at turn ", Character_movements.size()-1)
					#---------------------------------------------------------------------------
					obj.activate(self)
					break



#vrata
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




# Inventory
var inventory: Array[String] = []
var interactables: Array[Area2D] = []
var Interactables_position_dictionary = {}

func GetInventoryItems() -> String:
	return "Inventory:\n" + "\n".join(inventory)

func add_item(item_name: String):
	if item_name not in inventory:
		inventory.append(item_name)
		print("Picked up: ", item_name)

func has_item(item_name: String) -> bool:
	return item_name in inventory

func _on_InteractArea_area_entered(area):
	if area.has_method("activate"):
		interactables.append(area)

func _on_InteractArea_area_exited(area):
	if interactables.has(area):
		interactables.erase(area)

func remove_item(item_name: String):
	if item_name in inventory:
		inventory.erase(item_name)
		print("Removed item: ", item_name)
