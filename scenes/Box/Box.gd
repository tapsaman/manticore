extends KinematicBody2D

var type = "box"
var isPickable = false
var flying = false
var velocity
var speed = 1000

func pickedUp():
	$CollisionShape2D.disabled = true

func throw(_velocity):
	flying = true
	velocity = _velocity

func _process(delta):
	if flying:
		move_and_collide(velocity * speed * delta)
		set_rotation(get_rotation() + 1)

#func getPickedUpBy(player):
	
