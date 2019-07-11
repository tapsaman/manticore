extends Area2D

export(int) var throwSpeed = 1000
export(float) var throwRotateSpeed = 0.6
export(int) var damage = 5

var throwVelocity
var player

func initFromPickable(pickable):
	# Get fly/damage attributes from the pickable object
	throwSpeed = pickable.throwSpeed
	throwRotateSpeed = pickable.throwRotateSpeed
	damage = pickable.damage
	
	# Get sprite and collision shape from the pickable object
	var sprite = pickable.get_node("Sprite")
	var collisionShape2D = pickable.get_node("CollisionShape2D")

	pickable.remove_child(sprite)
	pickable.remove_child(collisionShape2D)

	add_child(sprite)
	add_child(collisionShape2D)

func getThrownBy(_player, velocity):
	player = _player
	
	# Set throwing direction to player's last movement direction
	throwVelocity = velocity if velocity else player.lastVelocity

	# Set position to player global holding position
	position = _player.position

func _process(delta):
	position += throwVelocity * throwSpeed * delta
	#set_rotation(get_rotation() + throwRotateSpeed)

func _on_Projectile_body_entered(collider):
	if collider != player and collider.has_method("getHitBy"):
		collider.getHitBy(self)
		collideAndBreak()
	elif collider is StaticBody2D or collider is TileMap:
		collideAndBreak()

func collideAndBreak():
	queue_free()