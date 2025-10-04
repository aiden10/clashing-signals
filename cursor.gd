extends CharacterBody2D

@export var player: Constants.PLAYERS
var speed: float
var crosshair: CenterContainer

func _init() -> void:
	self.speed = Constants.CURSOR_SPEED
	
	crosshair = get_child(1)

func _ready() -> void:
	crosshair = $Crosshair
	if player == Constants.PLAYERS.P1:
		crosshair.crosshairColor = Constants.COLOR_P1
	else:
		crosshair.crosshairColor = Constants.COLOR_P2
	crosshair.update_crosshair()

func _physics_process(delta: float) -> void:
	var x = self.get_parent()
	var prefix = "p1_" if (player == Constants.PLAYERS.P1) else "p2_"
	var direction := Vector2.ZERO
	if Input.is_action_pressed(prefix + "up"):
		direction.y -= 1
	if Input.is_action_pressed(prefix + "down"):
		direction.y += 1
	if Input.is_action_pressed(prefix + "left"):
		direction.x -= 1
	if Input.is_action_pressed(prefix + "right"):
		direction.x += 1

	if direction != Vector2.ZERO:
		self.move_and_collide(direction.normalized() * self.speed * delta)
