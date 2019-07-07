extends Node

const PickableClass = preload("res://scenes/Pickable/Pickable.gd")

var player
var id
var rayCast
var rayCastDefaultCast

const STATES = {
	"SEARCH_CRATE":		0,
	"MOVE":				1,
	"SEARCH_TARGET":	2,
	"FINISHED":			3
}

var currentState = 0
var coroutine = null
var moveTo
var velocity

func init(_player):
	player = _player
	id = "P" + str(player.playerNum + 1)
	rayCast = player.get_node("RayCast2D")
	rayCastDefaultCast = rayCast.get_cast_to()
	pass

func _process(delta):
	match currentState:
		STATES.SEARCH_CRATE:
			if !coroutine:
				coroutine = findClosestCrateGenerator()
			else:
				coroutine = coroutine.resume()
				
				if !(coroutine is GDScriptFunctionState):
					var closestCrate = coroutine
					coroutine = null

					if closestCrate:
						moveTo = closestCrate.position
						velocity = player.position.direction_to(moveTo)
						currentState = STATES.MOVE
					else:
						# No crates
						currentState = STATES.FINISHED
		
		STATES.MOVE:
			var collider = rayCast.get_collider()

			if collider and collider is PickableClass:
				# Detected something with RayCast
				player.holdingItem = collider.getPickedUpBy(player)
				if player.holdingItem:
					currentState = STATES.SEARCH_TARGET
				else:
					currentState = STATES.SEARCH_CRATE

			elif player.position.distance_to(moveTo) > 5:
				# Move closer to moveTo
				player.move_and_collide(velocity * player.speed * delta)
				rayCast.set_rotation(rayCastDefaultCast.angle_to(velocity))

			else:
				# At moveTo but no crate is seen here anymore
				currentState = STATES.SEARCH_CRATE

		STATES.SEARCH_TARGET:
			if !coroutine:
				coroutine = findClosestPlayerGenerator()
			else:
				coroutine = coroutine.resume()
				
				if !(coroutine is GDScriptFunctionState):
					var closestPlayer = coroutine
					coroutine = null

					if closestPlayer:
						var throwVelocity = player.position.direction_to(closestPlayer.position)
						player.holdingItem.getThrownBy(player, throwVelocity)
						player.holdingItem = null

						currentState = STATES.MOVE
					else:
						# No players found
						print("Unexpected case: findClosestPlayerGenerator found no target players - game should be over")
						currentState = STATES.FINISHED

	pass
	
func findClosestCrateGenerator():
	var minDistance = null
	var closest = null
	
	for crate in player.stage.crates:
		var distance = player.position.distance_to(crate.position)
		
		if minDistance == null or minDistance > distance:
			minDistance = distance
			closest = crate
		
		yield()
		
	return closest

func findClosestPlayerGenerator():
	var minDistance = null
	var closest = null
	
	for i in range(50):
		# artificial "targeting" wait time
		yield()

	for plr in player.stage.players:
		if plr == player:
			continue

		var distance = player.position.distance_to(plr.position)
		
		if minDistance == null or minDistance > distance:
			minDistance = distance
			closest = plr
		
		yield()
	
	return closest