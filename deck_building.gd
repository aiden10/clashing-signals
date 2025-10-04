extends Node


var players: Array[Node]

func _ready() -> void:
	players = get_children()
	print("[scene]", players)
	players[0].ready_element.ready_pressed.connect(ready_pressed)
	players[1].ready_element.ready_pressed.connect(ready_pressed)

func ready_pressed():
	print(self, players)
	if players[0].is_ready and players[1].is_ready:
		print("switch scenes")
