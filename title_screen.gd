extends Control


func _on_button_pressed() -> void:
	GameStateManager.goto_scene(Constants.GAME_SCENES.DECK)
