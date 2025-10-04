extends CharacterBody2D

@export var player: Constants.PLAYERS
var speed: float

func _init() -> void:
	self.speed = Constants.CURSOR_SPEED

func _ready() -> void:
	$Sprite2D.texture = load("res://assets/cursor1.png") if self.player == Constants.PLAYERS.P1 else load("res://assets/cursor2.png")
