extends GridContainer
# reuses hand functionality but adds card removal and different max size
class_name CustomizableDeck

@export var empty_name: String
@export var empty_image: Texture2D
@export var empty_cost: String

@export var player_ID: Constants.PLAYERS

@export var card_overview: Node


var max_size: int
var player: Constants.PLAYERS
@export var cards: Array[Card] = []
var displayed_cards: Array[CardDisplay] = []
var num_displayed: int = 8
var selected_index: int = 0

signal switched_element
signal card_removed


func _ready() -> void:
	self.max_size = Constants.MAX_DECK_SIZE
	cards.resize(max_size)
	for node in get_children():
		if node is CardDisplay:
			node.name_label.add_theme_font_size_override("font_size", 22)
			displayed_cards.append(node)

func add_card(card: Card, index: int) -> void:
	cards[index] = card
	displayed_cards[index].setup(card.name, card.image, card.cost)
	displayed_cards[index].name_label.add_theme_font_size_override("font_size", 22)
	
func handle_input(input: Dictionary) -> void:
	if input["up"]:
		if selected_index - self.columns >= 0: 
			selected_index -= self.columns 
			update_selection(selected_index)
		else:
			displayed_cards[selected_index].unhighlight()
			var pos = displayed_cards[selected_index].get_global_position() + displayed_cards[selected_index].size / 2
			switched_element.emit(Vector2.RIGHT, pos)
	if input["down"]:
		if selected_index + self.columns < num_displayed:
			selected_index += self.columns 
			update_selection(selected_index)
		else:
			displayed_cards[selected_index].unhighlight()
			var pos = displayed_cards[selected_index].get_global_position() + displayed_cards[selected_index].size / 2
			switched_element.emit(Vector2.DOWN, pos)
	if input["left"]:
		if selected_index % self.columns != 0:
			selected_index -= 1
			update_selection(selected_index)
	if input["right"]:
		if selected_index % self.columns != self.columns - 1:
			selected_index += 1
			update_selection(selected_index)
		else:
			displayed_cards[selected_index].unhighlight()
			var pos = displayed_cards[selected_index].get_global_position() + displayed_cards[selected_index].size / 2
			switched_element.emit(Vector2.RIGHT, pos)
	if input["use"]:
		card_removed.emit(selected_index)

func remove_card(index: int):
	cards[index] = null
	displayed_cards[index].setup(empty_name, empty_image, empty_cost)

func next_card(): 
	self.selected_index = (self.selected_index + 1) % self.cards.size() 
	
func prev_card(): 
	self.selected_index = (self.selected_index - 1 + self.cards.size()) % self.cards.size()

func get_selected() -> Card:
	return self.cards[self.selected_index]

func update_selection(index: int) -> void:
	for i in range(displayed_cards.size()):
		if i == index:
			displayed_cards[i].highlight()
		else:
			displayed_cards[i].unhighlight()
	if cards[index] != null:
		card_overview.update(cards[index])

func find_available_slot() -> int:
	for i in range(displayed_cards.size()):
		print(i, displayed_cards[i].is_empty())
		if displayed_cards[i].is_empty():
			return i
		
	return -1
	
func focus(index: int = 0) -> void:
	selected_index = index
	if cards.size() > 0:
		displayed_cards[selected_index].highlight()
