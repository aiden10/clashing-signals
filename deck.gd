extends Node
class_name Deck

var cards: Array[Card] = []

func draw_card() -> Card:
	return self.cards.pick_random()
