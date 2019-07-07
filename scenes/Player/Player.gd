extends KinematicBody2D

var PlayerControllerClass = preload("res://scenes/Player/PlayerController.gd")
var BotControllerClass = preload("res://scenes/Player/BotController.gd")

export(int) var speed = 400
export(int) var playerNum = 0
export(bool) var isBot = false
var rayCastDefaultCast
var lastVelocity = Vector2(0, 1)
var holdingItem = null
const holdingPosition = Vector2(0, -25)
var controller
var stage = null
var health = 100
signal health_changed

func _ready():
	if playerNum == 0:
		controller = PlayerControllerClass.new()
	else:
		controller = BotControllerClass.new()
		speed = 150
		
	controller.init(self)
	add_child(controller)
	
func getHitBy(projectile):
	var oldHealth = health
	var damage = projectile.damage
	health -= damage

	print("plr" + str(playerNum) + " hp -> " + str(oldHealth) + " - " + str(damage) + " = " + str(health))

	emit_signal("health_changed", playerNum, oldHealth, health)