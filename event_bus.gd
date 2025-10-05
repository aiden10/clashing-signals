extends Node

signal game_started
signal tower_destroyed
signal unit_died
signal building_destroyed
signal invalid_action
signal hand_updated(player: Constants.PLAYERS)
signal damage_taken
signal selection_updated(player: Constants.PLAYERS, index: int)
signal elixir_updated
signal game_over(winner: Constants.PLAYERS)
