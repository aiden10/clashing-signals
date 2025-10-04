extends Panel

var deck: Array[Card]
@export var player_ID: Constants.PLAYERS

@export var card_selection_element: Node
@export var deck_element: Node
@export var ready_element: Node


var current_area: Constants.SelectionArea = Constants.SelectionArea.SELECTION
var is_ready:bool = false


func _ready() -> void:
	deck.resize(8)
	
	$CardSelectionBox.card_added.connect(add_card)
	$CardSelectionBox.switched_element.connect(switch_element)
	$CardSelectionBox.player_ID = player_ID
	
	$Deck.switched_element.connect(switch_element)
	$Deck.card_removed.connect(remove_card)
	
	$ReadyButton.switched_element.connect(switch_element)
	$ReadyButton.ready_pressed.connect(on_ready_pressed)

	
	$"Panel/Label".text = str(Constants.PLAYERS.keys()[player_ID])

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
			$CardSelectionBox.handle_input(input)
		Constants.SelectionArea.DECK:
			$Deck.handle_input(input)
		Constants.SelectionArea.READY:
			pass
			$ReadyButton.handle_input(input)

func switch_element(direction: Vector2, from_pos: Vector2) -> void:
	match direction:
		Vector2.UP:
			current_area = Constants.SelectionArea.DECK
			var index = find_nearest($Deck.displayed_cards, from_pos)
			$Deck.focus(index)

		Vector2.DOWN:
			current_area = Constants.SelectionArea.SELECTION
			var index = find_nearest($CardSelectionBox.displayed_cards, from_pos)
			$CardSelectionBox.focus(index)

		Vector2.RIGHT:
			current_area = Constants.SelectionArea.READY
			$ReadyButton.highlight()
		
		Vector2.LEFT:
			current_area = Constants.SelectionArea.DECK
			var index = find_nearest($Deck.displayed_cards, from_pos)
			$Deck.focus(index)
			

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

func add_card(card: Card):
	var slot = deck_element.find_available_slot()
	if slot != -1:
		deck[slot] = card
		$Deck.add_card(card, slot)
	return

func remove_card(index: int):
	deck[index] = null
	$Deck.remove_card(index)


func on_ready_pressed():
	if deck_element.find_available_slot() == -1:
		if !is_ready:
			$ReadyButton/Label.text = "Ready!"
		else:
			$ReadyButton/Label.text = "Not Ready"
		is_ready = !is_ready
	else:
		print("please fill in all slots first")
