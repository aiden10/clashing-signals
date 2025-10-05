extends Node

var players: Array[Node]

func _ready() -> void:
	get_tree().paused = false
	players = get_children()
	print("[scene]", players)
	players[0].ready_element.ready_pressed.connect(ready_pressed)
	players[1].ready_element.ready_pressed.connect(ready_pressed)
	$Button.pressed.connect(func(): DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN))
	
func ready_pressed():
	if players[0].is_ready and players[1].is_ready:
		GameState.p1_deck = players[0].deck
		GameState.p2_deck = players[1].deck
		GameStateManager.goto_scene(Constants.GAME_SCENES.GAME)
