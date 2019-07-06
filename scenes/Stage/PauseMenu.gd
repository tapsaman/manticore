extends Control

onready var isPaused = false

func _ready():
	#White-list pause
	pause_mode = Node.PAUSE_MODE_PROCESS

func _process(delta):
	
	if Input.is_action_just_released('ui_home'):
		if isPaused:
			print('unpaused')
			$PauseText.visible = false
			get_tree().paused = false
			isPaused = false
		else:
			print('paused')
			$PauseText.visible = true
			get_tree().paused = true
			isPaused = true