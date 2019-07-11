extends Area2D

const ACCELERATION_RATE = 1200
const BRAKE_RATE = 1800
const MAX_SPEED = 450
const PUSH_THRESHOLD_SPEED = MAX_SPEED

onready var current_state

onready var current_dir = Vector2.ZERO
onready var desired_dir = Vector2.ZERO
onready var velocity = Vector2.ZERO

onready var speed = 0
onready var ticker = 0

func _ready():
	
	state_change("STATE_IDLE")
	
	pass

func _process(delta):
	
	state_handle_input(current_state)
	
	if Input.is_action_just_released('ui_select'):
		on_projectile_collision(test_push())
	
	if ticker > 1:
		print(desired_dir.normalized() )
		print(speed)
		ticker = 0
	else:
		ticker += delta
		
		update_pointer()
	pass


func _physics_process(delta):
	
	#Get desired movement direction
	state_update(current_state, delta)

	#Update velocity
	velocity = current_dir * speed
	
	#Apply velocity
	position += velocity * delta
	
	for ol in get_overlapping_bodies():
		if ol.name == 'Map':
			bounce()
	
	pass

func bounce():
	velocity = velocity.reflect(current_dir)
	pass


#State stuff
func state_change(new_state):
	
	print("State changed to " + new_state)
	
	state_exit(current_state)
	current_state = new_state
	state_enter(current_state)

func state_enter(state):
	
	match state:
		"STATE_IDLE":
			$StateLabel.text = "IDLE"
			current_dir = Vector2.ZERO
			pass
		"STATE_BRAKE":
			$StateLabel.text = "BRAKE"
			pass
		"STATE_RUN":
			$StateLabel.text = "RUN"
			pass
		"STATE_PUSHED":
			$StateLabel.text = "PUSHED"
			pass

	pass

func state_exit(state):
	
	match state:
		"STATE_IDLE":
			pass
		"STATE_BRAKE":
			pass
		"STATE_RUN":
			pass
		"STATE_PUSHED":
			pass
			
	pass

func state_handle_input(state):
	
	match state:
		"STATE_IDLE":
			if Input.is_action_pressed('ui_right') \
			or Input.is_action_pressed('ui_left') \
			or Input.is_action_pressed('ui_down') \
			or Input.is_action_pressed('ui_up'):
				state_change('STATE_RUN')
				pass
			pass
			
		"STATE_RUN":
			pass
			
		"STATE_BRAKE":
			if Input.is_action_pressed('ui_right') \
			or Input.is_action_pressed('ui_left') \
			or Input.is_action_pressed('ui_down') \
			or Input.is_action_pressed('ui_up'):
				state_change('STATE_RUN')
				pass
			pass

		"STATE_PUSHED":
			pass
			
		_:
			pass
	pass
	
	pass

func state_update(state, dt):
	match state:
		"STATE_IDLE":

			pass
			
			pass
			
		"STATE_BRAKE":
			if speed > 0:
				brake(dt)
			else:
				state_change("STATE_IDLE")
			
			pass
		"STATE_RUN":
			var is_running = false
			
			#Get run dir
			desired_dir = Vector2.ZERO
			
			if Input.is_action_pressed('ui_right'):
				is_running = true
				desired_dir.x = 1
				pass
			if Input.is_action_pressed('ui_left'):
				is_running = true
				desired_dir.x = -1
				pass
			if Input.is_action_pressed('ui_down'):
				is_running = true
				desired_dir.y = 1
				pass
			if Input.is_action_pressed('ui_up'):
				is_running = true
				desired_dir.y = -1
				pass
				
			if current_dir == Vector2.ZERO:
				current_dir = desired_dir
			
			if is_running:
				accelerate(dt)
				current_dir = lerp(current_dir, desired_dir.normalized(), 0.1)
				
			else:
				state_change("STATE_BRAKE")
			pass

		"STATE_PUSHED":
			brake(dt)
			
			if speed < PUSH_THRESHOLD_SPEED:
				state_change("STATE_BRAKE")
			
			pass
	pass
	

#Movement
func accelerate(d):
	if speed < MAX_SPEED:
		speed += ACCELERATION_RATE * d
	pass

func brake(d):

	speed -= BRAKE_RATE * d
	
	if speed < 10:
		speed = 0
	
	pass

#
func on_projectile_collision(projectile_velocity):
	
	var collision_speed = projectile_velocity.length()
	current_dir = (current_dir + projectile_velocity).normalized()
	
	speed += collision_speed
	if speed > PUSH_THRESHOLD_SPEED:
		state_change("STATE_PUSHED")
	
	pass

#
func test_push():

	var push_speed = 500
	var push_dir = Vector2(rand_range(-1, 1),rand_range(-1, 1)).normalized()

	return push_dir * push_speed

	pass


func update_pointer():
	
	$CurrentHeading.rotation = current_dir.angle()
	$DesiredHeading.rotation = desired_dir.angle()
	
	pass

