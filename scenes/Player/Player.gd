extends KinematicBody2D

export(int) var speed = 400
var rayCastDefaultCast
var lastVelocity = Vector2(0, 1)
var holdingItem = null
var holdingPosition = Vector2(0, -25)

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
		if holdingItem == null:
			var collider = $RayCast2D.get_collider()
			if collider and collider.isPickable:
				holdingItem = collider.getPickedUpBy(self)
		else:
			holdingItem.getThrownBy(self)
			holdingItem = null