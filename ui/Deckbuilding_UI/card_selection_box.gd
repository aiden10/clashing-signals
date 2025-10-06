extends GridContainer
class_name SelectionBox

var available_cards: Array[Card] # for debugging, add cards here to make them appear in deckbuilding
@export var player_ID: Constants.PLAYERS
@export var card_overview: Node
var displayed_cards: Array[CardDisplay]
var num_displayed: int
var selected_index: int = 3

signal switched_element
signal card_add_success(card: Card)
signal card_remove_success(card: Card)
signal card_toggle(card: Card)

func _ready() -> void:
	available_cards = Constants.CARDS
	
	for node in get_children():
		if node is CardDisplay:
			displayed_cards.append(node)
			node.name_label.add_theme_font_size_override("font_size", 22)

	for i in range(available_cards.size()):
		displayed_cards[i].setup(available_cards[i].name,available_cards[i].image, available_cards[i].cost)
		displayed_cards[i].name_label.add_theme_font_size_override("font_size", 22)
	num_displayed = displayed_cards.size()
	
	card_add_success.connect(_on_card_add_success)
	card_remove_success.connect(_on_card_remove_success)
	update_selection(selected_index)

func _on_card_add_success(card: Card) -> void:
	displayed_cards[available_cards.find(card)].invalid_selection()

func _on_card_remove_success(card: Card) -> void:
	displayed_cards[available_cards.find(card)].valid_selection()

func handle_input(input: Dictionary) -> void:
	if input["up"]:
		if selected_index - self.columns >= 0: 
			selected_index -= self.columns 
			update_selection(selected_index)
		else:
			displayed_cards[selected_index].unhighlight()
			var pos = displayed_cards[selected_index].get_global_position() + displayed_cards[selected_index].size / 2
			switched_element.emit(Vector2.UP, pos)
	elif input["down"]:
		if selected_index + self.columns < num_displayed:
			selected_index += self.columns 
			update_selection(selected_index)
	elif input["left"]:
		if selected_index % columns != 0:
			selected_index -= 1
			update_selection(selected_index)
	elif input["right"]:
		if selected_index % columns != columns - 1:
			selected_index += 1
			update_selection(selected_index)
		else:
			displayed_cards[selected_index].unhighlight()
			var pos = displayed_cards[selected_index].get_global_position() + displayed_cards[selected_index].size / 2
			switched_element.emit(Vector2.RIGHT, pos)

	elif input["use"]:
		if selected_index < available_cards.size():
			card_toggle.emit(available_cards[selected_index % available_cards.size()])
		
		
func update_selection(index: int) -> void:
	EventBus.card_selected.emit()
	for i in range(displayed_cards.size()):
		if i == index:
			displayed_cards[i].highlight()
		else:
			displayed_cards[i].unhighlight()
	if available_cards.size() - 1 >= index:
		if available_cards[index] != null:
			card_overview.update(available_cards[index])

func focus(index: int = 0) -> void:
	selected_index = index
	update_selection(selected_index)
