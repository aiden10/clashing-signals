extends Node

signal game_started
signal hand_updated(player: Constants.PLAYERS)
signal selection_updated(player: Constants.PLAYERS, index: int)
signal elixir_updated
signal tower_destroyed
signal unit_died
signal building_destroyed
signal invalid_action
signal damage_taken
signal building_placed
signal spell_cast
signal unit_placed

signal ready_pressed
signal card_selected

signal pause_pressed
signal unpaused
signal game_over(winner: Constants.PLAYERS)
