extends Node
class_name Deck


var cards: Array[Card] = []
var card_pool: Array[int] = []

func _ready() -> void:
	reset_pool()

func reset_pool() -> void:
	card_pool.clear()
	for i in range(cards.size()):
		card_pool.append(i)
	card_pool.shuffle()

func draw_card() -> Card:
	if card_pool.is_empty():
		reset_pool()
	var idx = card_pool.pop_back()
	return cards[idx]
