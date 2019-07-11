extends Node

#Viewport

#Camera
onready var cam = $StageCamera
export(float) var camShakeAmount = 0 #How intense is the camera shake
export(float) var camShakeBleed = 0.1 #How much camera shake lowers per tick

#Game world objects
export(PackedScene) var playerScene = load("res://scenes/Player/Player.tscn")
export(PackedScene) var crateScene = load("res://scenes/Pickable/Crate.tscn")

#Export packed scene map
export(PackedScene) var mapScene = load("res://scenes/Map/Map.tscn")
var map # node for ^

#Mode stuff
const BattleModeClass = preload("res://scenes/Stage/Controllers/BattleMode.gd")

enum MODE {
	BATTLE,
	SCORE_ATTACK,
	HOARDING
}

export(MODE) var mode = MODE.BATTLE

var controller
var mapWidth
var mapHeight

#Holders for map object instances, needed for bot controller logic
var players = []
var crates = []

func _ready():
	if mode == MODE.BATTLE:
		controller = BattleModeClass.new()
	else:
		# tough shit it's all we've got
		controller = BattleModeClass.new()

	controller.init(self)
	startGame()
	
func startGame():
	
	initMap()
	initCamera()
	controller.startGame()

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
	for c in map.get_used_cells_by_id(1):
		addPlayerTo(c)
		map.set_cell(c.x, c.y, -1) #Delete cell

	#Crates
	for c in map.get_used_cells_by_id(2):
		addCrateTo(c)
		map.set_cell(c.x, c.y, -1) #Delete cell

	# Get map height/width from last used cell
	var usedCells = map.get_used_cells()
	var lastCell = usedCells[ usedCells.size()-1 ]

	mapWidth = int(lastCell.x)
	mapHeight = int(lastCell.y)

	#Check where thing1
	#Check where thing2
	pass

func initCamera():
	
	#Position camera to center of map
	var mapSize = map.get_used_rect().size * map.cell_size
	cam.position = map.position + mapSize / 2
	#Set pausemenu margin
	cam.current = true

func addPlayerTo(pos):
	var player = playerScene.instance()
	player.position = pos * map.cell_size + map.cell_size / 2
	player.playerNum = players.size()
	player.isBot = player.playerNum != 0
	player.stage = self
	player.connect("health_changed", self, "_on_Player_health_changed")
	players.push_back(player)
	add_child(player)
	pass

func addCrateTo(pos):
	var crate = crateScene.instance()
	crate.position = pos * map.cell_size + map.cell_size / 2
	crate.connect("pickable_lifted", self, "_on_Crate_pickable_lifted")
	crates.push_back(crate)
	add_child(crate)
	pass

func _on_Player_health_changed(playerNum, oldHealth, newHealth):
	#Shake on damage
	if oldHealth > newHealth:
		var damage = oldHealth - newHealth
		camShakeAmount = damage / 2
		#Log for debug
		print("plr" + str(playerNum) + " took " + str(damage) + " damage, HP = " + str(newHealth))
	pass

func _on_Crate_pickable_lifted(crate):
	# Remove crate from crates array when it is lifted
	crates.erase(crate)
	pass

func getRandomMapCell():
	# Cell x/y's

	# Reduce all by one to avoid borders 
	var minX = 1
	var maxX = mapWidth - 1
	var minY = 1
	var maxY = mapHeight - 1

	# Can be changed to floats with rand_range([min], [max])
	var x = randi() % maxX + minX
	var y = randi() % maxY + minY

	return Vector2(x, y)

func cellIsEmpty(pos):
	$EmptyCellChecker.position = pos * map.cell_size + map.cell_size / 2
	var overlap = $EmptyCellChecker.get_overlapping_bodies()

	if overlap.size():
		print("EmptyCellChecker overlaps with", overlap)
		return false

	return true