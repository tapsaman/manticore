extends KinematicBody2D

export(int) var throwSpeed = 1000
export(float) var throwRotateSpeed = 0.6
var throwVelocity
const isPickable = true

# Returns the item player picked up (self or null if)
func getPickedUpBy(player):
	$CollisionShape2D.disabled = true
	get_parent().remove_child(self)
	player.add_child(self)
	position = Vector2(0, -25)
	return self

func getThrownBy(player):
	throwVelocity = player.lastVelocity
	var scene = get_tree().get_current_scene()
	get_parent().remove_child(self)
	scene.add_child(self)
	print(scene)
	position = Vector2(player.position.x, player.position.y-25)

func _process(delta):
	if throwVelocity:
		move_and_collide(throwVelocity * throwSpeed * delta)
		set_rotation(get_rotation() + throwRotateSpeed)