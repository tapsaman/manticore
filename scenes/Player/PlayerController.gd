extends Node

var PickableClass = preload("res://scenes/Pickable/Pickable.gd")

var player
var id
var keys
var rayCast
var rayCastDefaultCast

func init(_player):
	player = _player
	id = "P" + str(player.playerNum + 1)
	keys = {
		"Up":		id + "_Up",
		"Right":	id + "_Right",
		"Down":		id + "_Down",
		"Left":		id + "_Left",
		"Select":	id + "_Select"
	}
	rayCast = player.get_node("RayCast2D")
	rayCastDefaultCast = rayCast.get_cast_to()

func _process(delta):
	var velocity = Vector2()

	if Input.is_action_pressed(keys["Up"]):
		velocity.y -= 1
	if Input.is_action_pressed(keys["Right"]):
		velocity.x += 1
	if Input.is_action_pressed(keys["Down"]):
		velocity.y += 1
	if Input.is_action_pressed(keys["Left"]):
		velocity.x -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized()
		player.move_and_collide(velocity * player.speed * delta)
		rayCast.set_rotation(rayCastDefaultCast.angle_to(velocity))
		player.lastVelocity = velocity

func _input(event):
	if event.is_action_released(keys["Select"]):
		if player.holdingItem == null:
			var collider = rayCast.get_collider()
			if collider and collider is PickableClass:
				player.holdingItem = collider.getPickedUpBy(player)
		else:
			player.holdingItem.getThrownBy(player)
			player.holdingItem = null