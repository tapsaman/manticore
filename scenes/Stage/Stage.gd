extends Node

#Viewport

#Camera
onready var cam = $StageCamera
export(float) var camShakeAmount = 5.0 #How intense is the camera shake
export(float) var camShakeBleed = 0.1 #How much camera shake lowers per tick

#Game world objects
export(PackedScene) var playerScene = load("res://scenes/Player/Player.tscn")
export(PackedScene) var crateScene = load("res://scenes/Pickable/Crate.tscn")

#Export packed scene map
export(PackedScene) var mapScene = load("res://scenes/Map/Map.tscn")
var map # node for ^

#Holders for map object instances, needed for bot controller logic
var players = []
var crates = []

func _ready():
	
	initMap()
	initCamera()
	

func _process(delta):
	
	#NOTE: Tie to delta at some point
	if camShakeAmount > 0.0:
		shakeCamera(camShakeAmount)
		camShakeAmount -= camShakeBleed
		if camShakeAmount < 0.1:
			camShakeAmount = 0.0
			cam.set_offset(Vector2.ZERO)

func shakeCamera(n):
	
	cam.set_offset(Vector2(rand_range(-1.0, 1.0) * n, rand_range(-1.0, 1.0) * n))

#Initialize the map
func initMap():
	
	#Add map to stage
	map = mapScene.instance()
	add_child(map)
	
	#Go over tiles and add stuff based on that
	
	#id of thing1 = 1 < spawn player here
	#id of thing2 = 2 < box here

	#Player
	var pIndex = 0
	
	for c in map.get_used_cells_by_id(1):
		var player = playerScene.instance()
		player.position = c * map.cell_size + map.cell_size / 2
		player.playerNum = 0 if pIndex == 0 else 1
		player.stage = self
		add_child(player)
		players.push_back(player)
		map.set_cell(c.x, c.y, -1) #Delete cell
		pIndex += 1

		player.connect("health_change", self, "_on_Player_health_change")
		
	#Crates
	for c in map.get_used_cells_by_id(2):
		var crate = crateScene.instance()
		crate.position = c * map.cell_size + map.cell_size / 2
		add_child(crate)
		map.set_cell(c.x, c.y, -1) #Delete cell
		crates.push_back(crate)

		crate.connect("pickable_lifted", self, "_on_Crate_pickable_lifted")
		
	#Check where thing1
	#Check where thing2
	pass

func initCamera():
	
	#Position camera to center of map
	var mapSize = map.get_used_rect().size * map.cell_size
	cam.position = map.position + mapSize / 2
	#Set pausemenu margin
	cam.current = true

func _on_Player_health_change(playerNum, oldHealth, newHealth):
	pass

func _on_Crate_pickable_lifted(crate):
	crates.erase(crate)
	pass