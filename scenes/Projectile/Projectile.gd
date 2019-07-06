extends Area2D

export(int) var throwSpeed = 1000
export(float) var throwRotateSpeed = 0.6
var throwVelocity

func initFromPickable(pickable):
	# Get sprite and collision shape from the pickable object
	var sprite = pickable.get_node("Sprite")
	var collisionShape2D = pickable.get_node("CollisionShape2D")

	pickable.remove_child(sprite)
	pickable.remove_child(collisionShape2D)

	add_child(sprite)
	add_child(collisionShape2D)

func getThrownBy(player):
	# Set throwing direction to player's last movement direction
	throwVelocity = player.lastVelocity

	# Set position to player global holding position
	position = player.position + player.holdingPosition

func _process(delta):
	position += throwVelocity * throwSpeed * delta
	set_rotation(get_rotation() + throwRotateSpeed)

func _on_Projectile_body_entered(collider):
	print(collider)

	if collider is StaticBody2D:
		collideAndBreak()

func collideAndBreak():
	queue_free()