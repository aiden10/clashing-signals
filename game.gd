extends Node

var p1: Player
var p2: Player

func _init() -> void:
	## For the time being, we can just give both players all cards as their decks
	## But later we might want to store separate lists of cards in GameState
	## And then add to that from the deckbuilding menu
	p1 = Player.new()
	p1.player = Constants.PLAYERS.P1
	var p1_deck: Deck = Deck.new()
	
	# this check is here in case the game starts on game scene, preferably deckbuilding scene will switch to game scene
	if GameState.p1_deck.is_empty():
		p1_deck.cards = Constants.CARDS.duplicate(true)
	else:
		p1_deck.cards = GameState.p1_deck.duplicate(true)
	p1.deck = p1_deck
	
	p2 = Player.new()
	p2.player = Constants.PLAYERS.P2
	var p2_deck: Deck = Deck.new()
	if GameState.p1_deck.is_empty():
		p2_deck.cards = Constants.CARDS.duplicate(true)
	else:
		p2_deck.cards = GameState.p2_deck.duplicate(true)
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
	if p1.elixir < Constants.MAX_ELIXIR:
		p1.elixir += 1
	if p2.elixir < Constants.MAX_ELIXIR:
		p2.elixir += 1
	EventBus.elixir_updated.emit()

func check_game_over() -> void:
	if GameState.p1_towers.size() == 0:
		print("P1 Loses")
	if GameState.p2_towers.size() == 0:
		print("P2 Loses")
		
