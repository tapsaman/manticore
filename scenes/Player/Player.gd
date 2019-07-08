extends KinematicBody2D

const PlayerControllerClass = preload("res://scenes/Player/PlayerController.gd")
const BotControllerClass = preload("res://scenes/Player/BotController.gd")

export(int) var playerNum = 0
export(bool) var isBot = false
export(int) var speed = 400
var rayCastDefaultCast
var lastVelocity = Vector2(0, 1)
var holdingItem = null
const holdingPosition = Vector2(0, -25)
var controller
var stage = null
var health = 100
signal health_changed

func _ready():
	if isBot:
		controller = BotControllerClass.new()
		speed = 150
	else:
		controller = PlayerControllerClass.new()
		
	controller.init(self)
	add_child(controller)
	
func getHitBy(projectile):
	var oldHealth = health
	health -= projectile.damage

	emit_signal("health_changed", playerNum, oldHealth, health)