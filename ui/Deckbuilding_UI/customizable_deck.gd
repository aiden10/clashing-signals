extends Node
# reuses hand functionality but adds card removal and different max size

var max_size: int
var player: Constants.PLAYERS
var cards: Array[Card] = []
var displayed_cards: Array[CardDisplay] = []
var num_displayed: int = 8
var selected_index: int = 0

signal switched_element


func _ready() -> void:
	self.max_size = Constants.MAX_DECK_SIZE
	cards.resize(max_size)
	for node in get_children():
		if node is CardDisplay:
			displayed_cards.append(node)

func add_card(card: Card) -> void:
	
	var slot := find_available_slot()
	if slot == -1:
		push_warning("No available display slot for card: %s" % card.name)
		return
		
	cards.append(card)
	displayed_cards[slot].setup(card.name, card.image, card.cost)

func handle_input(input: Dictionary) -> void:
	if input["up"]:
		if selected_index - self.columns >= 0: 
			selected_index -= self.columns 
			update_selection(selected_index)
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
		print("Selected card:", get_selected())

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

func find_available_slot() -> int:
	for i in range(displayed_cards.size()):
		if displayed_cards[i].is_empty():
			return i
		
	return -1
	
func focus(index: int = 0) -> void:
	selected_index = index
	if cards.size() > 0:
		displayed_cards[selected_index].highlight()
