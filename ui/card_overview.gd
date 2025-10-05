extends Panel

@export var title: Label
@export var description: Label

func update(new_card: Card):
	title.text = new_card.name
	description.text = new_card.description
