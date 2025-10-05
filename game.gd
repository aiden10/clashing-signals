extends Node

@onready var elixir_timer: Timer = $ElixirTimer
@onready var stage1_timer: Timer = $Stage1Timer
@onready var stage2_timer: Timer = $Stage2Timer
@onready var fullscreen_button: Button = $CanvasLayer/FullscreenButton

var p1: Player
var p2: Player

func _init() -> void:
	p1 = Player.new()
	p1.player = Constants.PLAYERS.P1
	var p1_deck: Deck = Deck.new()
	
	GameState.game_instance = self
	
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
	fullscreen_button.pressed.connect(func(): GameStateManager.goto_scene(Constants.GAME_SCENES.DECK))
	EventBus.game_started.emit()
	EventBus.tower_destroyed.connect(check_game_over)
	elixir_timer.wait_time = Constants.ELIXIR_COOLDOWN
	elixir_timer.timeout.connect(add_elixir)
	
	stage1_timer.wait_time = Constants.STAGE1_DURATION
	stage1_timer.one_shot = true
	stage2_timer.wait_time = Constants.STAGE2_DURATION
	stage2_timer.one_shot = true
	stage2_timer.timeout.connect(func():
		elixir_timer.wait_time = Constants.ELIXIR_COOLDOWN3
	)
	stage1_timer.timeout.connect(func():
		elixir_timer.wait_time = Constants.ELIXIR_COOLDOWN2
		stage2_timer.start()
	)
	stage1_timer.start()
	
	stage1_timer.timeout.connect($CanvasLayer/PlayerDisplay1._on_stage1_timer)
	stage2_timer.timeout.connect($CanvasLayer/PlayerDisplay1._on_stage2_timer)
	
	p1.cursor = $P1/Cursor
	p2.cursor = $P2/Cursor
	add_child(p1)
	add_child(p2)
	
	for marker in $P1.get_children() + $P2.get_children():
		if marker is Marker2D:
			var tower: Building = Constants.TOWER_SCENE.instantiate()
			if marker.get_parent().name == "P1":
				tower.player = Constants.PLAYERS.P1
			elif marker.get_parent().name == "P2":
				tower.player = Constants.PLAYERS.P2
			tower.global_position = marker.global_position
			add_child(tower)

func add_elixir() -> void:
	if p1.elixir < Constants.MAX_ELIXIR:
		p1.elixir += 1
	if p2.elixir < Constants.MAX_ELIXIR:
		p2.elixir += 1
	EventBus.elixir_updated.emit()

func add_elixir_specific(player: Constants.PLAYERS) -> void:
	if player == Constants.PLAYERS.P1:
		if p1.elixir < Constants.MAX_ELIXIR:
			p1.elixir += 1
	if player == Constants.PLAYERS.P2:
		if p2.elixir < Constants.MAX_ELIXIR:
			p2.elixir += 1
	EventBus.elixir_updated.emit()

func check_game_over() -> void:
	print(GameState.p1_towers)
	print(GameState.p2_towers)
	if GameState.p1_towers.size() == 0:
		EventBus.game_over.emit(Constants.PLAYERS.P2)
		print("p2 wins")
	if GameState.p2_towers.size() == 0:
		EventBus.game_over.emit(Constants.PLAYERS.P1)
		print("p1 wins")
