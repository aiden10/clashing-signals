extends Node

@export var player1: PanelContainer
@export var player2: PanelContainer
@export var exit_button: Button

func _ready() -> void:
	get_tree().paused = false
	player1.ready_element.ready_pressed.connect(ready_pressed)
	player2.ready_element.ready_pressed.connect(ready_pressed)
	
	exit_button.pressed.connect(func():
		GameStateManager.goto_scene(Constants.GAME_SCENES.TITLE)
	)
	
func ready_pressed():
	EventBus.ready_pressed.emit()
	if player1.is_ready and player2.is_ready:
		GameState.p1_deck = player1.deck
		GameState.p2_deck = player2.deck
		GameStateManager.goto_scene(Constants.GAME_SCENES.GAME)
