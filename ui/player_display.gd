extends Control

@onready var hand: VBoxContainer = $PanelContainer/MarginContainer/Hand
@onready var elixir_bar: ProgressBar = $PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ElixirBar
@onready var elixir_label: Label = $PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ElixirLabel
@export var player: Constants.PLAYERS

var card_displays: Array = []

func _ready() -> void:
	EventBus.hand_updated.connect(update_hand)
	EventBus.elixir_updated.connect(update_elixir)
	EventBus.selection_updated.connect(update_hand_selection)

func update_hand(player_id: Constants.PLAYERS) -> void:
	if player_id != self.player:
		return

	for child in hand.get_children():
		if child is CardDisplay:
			hand.remove_child(child)
			child.queue_free()

	card_displays.clear()

	var hand_cards := GameState.p1.hand.cards if self.player == Constants.PLAYERS.P1 else GameState.p2.hand.cards

	for card in hand_cards:
		var card_display: CardDisplay = Constants.CARD_DISPLAY.instantiate()
		hand.add_child(card_display)
		card_display.setup(card.name, card.image, card.cost)
		card_displays.append(card_display)

	var p = GameState.p1 if self.player == Constants.PLAYERS.P1 else GameState.p2
	if p and p.hand:
		update_hand_selection(self.player, p.hand.selected_index)

func update_hand_selection(player_id: Constants.PLAYERS, index: int) -> void:
	if player_id != self.player:
		return

	for i in range(card_displays.size()):
		if i == index:
			card_displays[i].highlight()
		else:
			card_displays[i].unhighlight()

func update_elixir() -> void:
	var p = GameState.p1 if self.player == Constants.PLAYERS.P1 else GameState.p2
	if p:
		elixir_label.text = str(p.elixir)
		elixir_bar.value = p.elixir
