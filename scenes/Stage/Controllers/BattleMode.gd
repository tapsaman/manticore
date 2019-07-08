extends Node

var stage
var crateTimer
var maxCrates

func init(_stage):

	stage = _stage
	crateTimer = stage.get_node("CrateTimer")
	crateTimer.connect("timeout", self, "_on_CrateTimer_timeout")

func startGame():

	maxCrates = int(stage.mapWidth  * stage.mapHeight * 0.8)
	crateTimer.wait_time = rand_range(0.2, 1.6)
	crateTimer.start()

func _on_CrateTimer_timeout():

	# Create crate to a random map cell	
	if stage.crates.size() >= maxCrates:
		return

	var loc = stage.getRandomMapCell()

	# If cell is filled, immediately give up, try again next time
	if (stage.cellIsEmpty(loc)):
		stage.addCrateTo(loc)

	crateTimer.wait_time = rand_range(0.2, 1.6)

	pass