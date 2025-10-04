extends Node
class_name Hand

var max_size: int
var player: Constants.PLAYERS
var cards: Array[Card] = []
var selected_index: int = 0

func _init() -> void:
	self.max_size = Constants.MAX_HAND_SIZE

func add_card(card: Card) -> void:
	if self.cards.size() < max_size:
		self.cards.append(card)
		EventBus.hand_updated.emit(self.player)

func next_card() -> void:
	if self.cards.size() == 0:
		return
	
	self.selected_index = (self.selected_index + 1) % self.cards.size()
	EventBus.selection_updated.emit(self.player, self.selected_index)

func prev_card() -> void:
	if self.cards.size() == 0:
		return
	
	self.selected_index = (self.selected_index - 1 + self.cards.size()) % self.cards.size()
	EventBus.selection_updated.emit(self.player, self.selected_index)

func get_selected() -> Card:
	if self.selected_index < self.cards.size() && self.cards[self.selected_index]:
		return self.cards[self.selected_index]
	return null
