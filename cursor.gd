extends CharacterBody2D

@export var player: Constants.PLAYERS
signal switched_side

var speed: float
var prev_side: Constants.PLAYERS
var holding_spell: bool = false

func _init() -> void:
	self.speed = Constants.CURSOR_SPEED

func _ready() -> void:
	prev_side = get_side();
	set_valid_crosshair()
	EventBus.selection_updated.connect(_on_selection_updated)
	EventBus.hand_updated.connect(_on_hand_update)

func _process(_delta: float) -> void:
	if player == get_side() || holding_spell:
		set_valid_crosshair()
	else:
		if holding_spell: print(holding_spell)
		set_invalid_crosshair()

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
		
	if prev_side != get_side():
		switched_side.emit()
	prev_side = get_side()

func get_side() -> Constants.PLAYERS:
	if position.x <= 860:
		return Constants.PLAYERS.P1
	elif position.x >= 1060:
		return Constants.PLAYERS.P2
	elif player == Constants.PLAYERS.P1:
		return Constants.PLAYERS.P2
	else: # player == Constants.PLAYERS.P2
		return Constants.PLAYERS.P1
	
func get_default_color() -> Color:
	if player == Constants.PLAYERS.P1:
		return Constants.COLOR_P1
	else:
		return Constants.COLOR_P2

func _on_hand_update(received_player: Constants.PLAYERS) -> void:
	_on_selection_updated(received_player, 0)

func _on_selection_updated(received_player: Constants.PLAYERS, _selected_index) -> void:
	if received_player != player:
		return

	var selected_card
	if player == Constants.PLAYERS.P1:
		selected_card = GameState.p1.hand.get_selected()
	else:
		selected_card = GameState.p2.hand.get_selected()
	
	if selected_card:
		holding_spell = (selected_card.type == Constants.CARD_TYPES.SPELL)

func set_valid_crosshair() -> void:
	$Crosshair.crosshairColor = self.get_default_color()
	$Crosshair.update_crosshair()

func set_invalid_crosshair() -> void:
	$Crosshair.crosshairColor = get_default_color().darkened(Constants.INVALID_DARKENING)
	$Crosshair.update_crosshair()
