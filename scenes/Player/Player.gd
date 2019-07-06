extends KinematicBody2D

export var speed = 400
var rayCastDefaultCast
var pickedUpObject
var lastVelocity = Vector2(0, 1)

func _ready():
	rayCastDefaultCast = $RayCast2D.get_cast_to()

func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized()
		move_and_collide(velocity * speed * delta)
		var angle = rayCastDefaultCast.angle_to(velocity)
		$RayCast2D.set_rotation(angle)
		lastVelocity = velocity

func _input(event):
	if event.is_action_released("ui_select"):
		if !pickedUpObject:
			var collider = $RayCast2D.get_collider()
			if collider and collider.get("type") == "box":
				print("selected box")
				# remove box from scene, add to Player
				collider.get_parent().remove_child(collider)
				add_child(collider)
				collider.position = Vector2(0,-25)
				collider.pickedUp()
				pickedUpObject = collider
				#collider.getNode("CollisionShape2D").disabled = true
		else:
			print("throwing box")
			# remove box from Player, add to scene
			remove_child(pickedUpObject)
			get_parent().add_child(pickedUpObject)
			pickedUpObject.position = Vector2(position.x,position.y-25)
			pickedUpObject.throw(lastVelocity)
			pickedUpObject = null