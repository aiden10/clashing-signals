extends Control

@onready var hand: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Hand
@onready var elixir_bar: ProgressBar = $PanelContainer/MarginContainer/VBoxContainer/ElixirContainer/MarginContainer/VBoxContainer/ElixirBar
@onready var elixir_label: Label = $PanelContainer/MarginContainer/VBoxContainer/ElixirContainer/MarginContainer/VBoxContainer/ElixirLabel
@onready var draw_bar: ProgressBar = $PanelContainer/MarginContainer/VBoxContainer/DrawContainer/MarginContainer/VBoxContainer/DrawBar
@export var elixir_container: PanelContainer
@export var draw_container: PanelContainer
@export var player: Constants.PLAYERS

var draw_tween: Tween
var card_displays: Array = []

func _ready() -> void:
	draw_bar.max_value = Constants.DRAW_COOLDOWN
	EventBus.hand_updated.connect(update_hand)
	
	EventBus.elixir_updated.connect(update_elixir)
	EventBus.selection_updated.connect(update_hand_selection)

func _process(_delta: float) -> void:
	update_draw_progress()

func update_draw_progress() -> void:
	var draw_timer = GameState.p1.draw_timer if player == Constants.PLAYERS.P1 else GameState.p2.draw_timer
	if not draw_timer:
		return
	
	if draw_timer.is_stopped():
		draw_bar.value = Constants.DRAW_COOLDOWN
	else:
		draw_bar.value = Constants.DRAW_COOLDOWN - draw_timer.time_left
	
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
		if card:
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

func _on_stage1_timer() -> void:
	elixir_bar.get("theme_override_styles/fill").bg_color = Constants.STAGE2_COLOR

func _on_stage2_timer() -> void:
	elixir_bar.get("theme_override_styles/fill").bg_color = Constants.STAGE3_COLOR
