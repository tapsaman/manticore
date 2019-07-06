extends Node

#Player
export(PackedScene) var playerScene = load("res://scenes/Player/Player.tscn")

#Box
export(PackedScene) var boxScene = load("res://scenes/Pickable/Crate.tscn")

#Export packed scene map
export(PackedScene) var mapScene = load("res://scenes/Map/Map.tscn")
var map # node for ^

func _ready():
	
	loadMap()

	pass 

#Initialize the map
func loadMap():
	
	#Add map to stage
	map = mapScene.instance()
	add_child(map)
	
	#Go over tiles and add stuff based on that
	
	#id of thing1 = 1 < spawn player here
	#id of thing2 = 2 < box here

	print(str(map.cell_size))
	
	#Player
	for c in map.get_used_cells_by_id(1):
		var player = playerScene.instance()
		player.position = c * map.cell_size + map.cell_size / 2
		add_child(player)

	#Boxes
	for c in map.get_used_cells_by_id(2):
		var box = boxScene.instance()
		box.position = c * map.cell_size + map.cell_size / 2
		add_child(box)
		
	#Check where thing1
	#Check where thing2
	
	pass

