extends KinematicBody2D

export(PackedScene) var projectileScene = load("res://scenes/Projectile/Projectile.tscn")
export(int) var throwSpeed = 1000
export(float) var throwRotateSpeed = 0.6
export(int) var damage = 10

const isPickable = true
signal pickable_lifted

# Returns the item player will be holding (self or null)
func getPickedUpBy(player):
	# Disable collisions
	$CollisionShape2D.disabled = true

	# Move to player node
	get_parent().remove_child(self)
	player.add_child(self)

	# Set position to players holding position
	position = player.get_node('CarryPivot').position

	emit_signal("pickable_lifted", self)

	return self

func getThrownBy(player, velocity = null):
	# Enable collisions
	$CollisionShape2D.disabled = false

	# Add projectile instance to scene
	var projectile = projectileScene.instance()
	get_tree().get_current_scene().add_child(projectile)

	projectile.initFromPickable(self)
	projectile.getThrownBy(player, velocity)

	queue_free()