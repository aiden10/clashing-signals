extends Node

var p1: Player
var p2: Player

func _init() -> void:
	p1 = Player.new()
	p1.player = Constants.PLAYERS.P1
	var p1_deck: Deck = Deck.new()
	p1_deck.cards = [Constants.KNIGHT_CARD]
	p1.deck = p1_deck
	
	p2 = Player.new()
	p2.player = Constants.PLAYERS.P2
	var p2_deck: Deck = Deck.new()
	p2_deck.cards = [Constants.KNIGHT_CARD]
	p2.deck = p2_deck

func _ready() -> void:
	EventBus.tower_destroyed.connect(check_game_over)
	$ElixirTimer.wait_time = Constants.ELIXIR_COOLDOWN
	$ElixirTimer.timeout.connect(add_elixir)
	p1.cursor = $P1/Cursor
	p2.cursor = $P2/Cursor
	add_child(p1)
	add_child(p2)

func add_elixir() -> void:
	p1.elixir += 1
	p2.elixir += 1
	EventBus.elixir_updated.emit()

func check_game_over() -> void:
	if TowersState.p1_towers.size() == 0:
		print("P1 Loses")
	if TowersState.p2_towers.size() == 0:
		print("P2 Loses")
		
