extends Node

var game_instance: Node

var p1: Player
var p2: Player


var p1_deck: Array[Card]
var p2_deck: Array[Card]

var p1_towers = []
var p2_towers = []

@onready var elixir_timer: Timer = $ElixirTimer
@onready var stage1_timer: Timer = $Stage1Timer
@onready var stage2_timer: Timer = $Stage2Timer
