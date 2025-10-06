extends PanelContainer

var deck: Array[Card]
@export var player_ID: Constants.PLAYERS
@export var card_selection_element: SelectionBox
@export var deck_element: CustomizableDeck
@export var ready_element: PanelContainer
@export var ready_label: Label

var current_area: Constants.SelectionArea = Constants.SelectionArea.SELECTION
var is_ready:bool = false


func _ready() -> void:
	deck.resize(Constants.MAX_DECK_SIZE)

	card_selection_element.card_toggle.connect(toggle_card)
	card_selection_element.switched_element.connect(switch_element)
	card_selection_element.player_ID = player_ID
	
	deck_element.switched_element.connect(switch_element)
	deck_element.card_removed.connect(remove_card)
	
	ready_element.switched_element.connect(switch_element)
	ready_element.ready_pressed.connect(on_ready_pressed)
	
	$VBoxContainer/ColorRect/Label.text = str(Constants.PLAYERS.keys()[player_ID])

func _process(delta: float) -> void:
	var prefix = "p1_" if player_ID == Constants.PLAYERS.P1 else "p2_"

	# gather input once
	var input = {
		"up": Input.is_action_just_pressed(prefix + "up"),
		"down": Input.is_action_just_pressed(prefix + "down"),
		"left": Input.is_action_just_pressed(prefix + "left"),
		"right": Input.is_action_just_pressed(prefix + "right"),
		"use": Input.is_action_just_pressed(prefix + "use")
	}

	match current_area:
		Constants.SelectionArea.SELECTION:
			card_selection_element.handle_input(input)
		Constants.SelectionArea.DECK:
			deck_element.handle_input(input)
		Constants.SelectionArea.READY:
			pass
			ready_element.handle_input(input)

func switch_element(direction: Vector2, from_pos: Vector2) -> void:
	EventBus.card_selected.emit()
	match direction:
		Vector2.UP:
			if current_area == Constants.SelectionArea.SELECTION:
				current_area = Constants.SelectionArea.DECK
				var index = find_nearest(deck_element.displayed_cards, from_pos)
				deck_element.focus(index)
			elif current_area == Constants.SelectionArea.DECK:
				current_area = Constants.SelectionArea.READY
				ready_element.highlight()

		Vector2.DOWN:
			if current_area == Constants.SelectionArea.READY:
				current_area = Constants.SelectionArea.DECK
				var index = find_nearest(deck_element.displayed_cards, from_pos)
				deck_element.focus(index)
				
			elif current_area == Constants.SelectionArea.DECK:
				current_area = Constants.SelectionArea.SELECTION
				var index = find_nearest(card_selection_element.displayed_cards, from_pos)
				card_selection_element.focus(index)

		Vector2.RIGHT:
			pass
			current_area = Constants.SelectionArea.READY
			ready_element.highlight()
		
		Vector2.LEFT:
			current_area = Constants.SelectionArea.DECK
			var index = find_nearest(deck_element.displayed_cards, from_pos)
			deck_element.focus(index)
			
func find_nearest(elements: Array, from_pos: Vector2) -> int:
	var closest = 0
	var closest_dist = INF
	for i in range(elements.size()):
		var pos = elements[i].get_global_position() + elements[i].size / 2
		var dist = from_pos.distance_to(pos)
		if dist < closest_dist:
			closest_dist = dist
			closest = i
	return closest

func toggle_card(card: Card):
	EventBus.card_selected.emit()
	if card in deck_element.cards:
		remove_card(deck_element.cards.find(card))
	else:
		add_card(card)

func add_card(card: Card):
	var slot = deck_element.find_available_slot()
	if card not in deck_element.cards && slot != -1:
		deck[slot] = card
		deck_element.add_card(card, slot)
		card_selection_element.card_add_success.emit(card)
	return

func remove_card(index: int):
	if deck[index] == null:
		return
	
	card_selection_element.card_remove_success.emit(deck[index])
	
	deck[index] = null
	deck_element.remove_card(index)
	become_unready()

func become_ready() -> void:
	ready_label.text = "Ready!"

func become_unready() -> void:
	ready_label.text = "Select this to ready up"

func on_ready_pressed():
	if deck_element.find_available_slot() == -1:
		if !is_ready:
			become_ready()
		else:
			become_unready()
		is_ready = !is_ready
	else:
		print("please fill in all slots first")
