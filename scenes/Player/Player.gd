extends KinematicBody2D

var PlayerControllerClass = preload("res://scenes/Player/PlayerController.gd")

export(int) var speed = 400
export(int) var playerNum = 0
var rayCastDefaultCast
var lastVelocity = Vector2(0, 1)
var holdingItem = null
const holdingPosition = Vector2(0, -25)
var controller

func _ready():
	controller = PlayerControllerClass.new()
	controller.init(self)
	add_child(controller)