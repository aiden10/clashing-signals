extends Control

@onready var win_label: RichTextLabel = $VBoxContainer/WinLabel
@onready var lose_label: RichTextLabel = $VBoxContainer/LoseLabel

func _ready() -> void:
	modulate.a = 0
	win_label.visible_ratio = 0
	lose_label.visible_ratio = 0
	$VBoxContainer/Button.disabled = false
	$VBoxContainer/Button.pressed.connect(func(): GameStateManager.goto_scene(Constants.GAME_SCENES.DECK))

func display(winner: Constants.PLAYERS):
	GameState.game_over = true
	get_tree().paused = true
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 1.0, 0.5)
	fade_tween.finished.connect(func(): display(winner))

	if winner == Constants.PLAYERS.P1:
		win_label.text = "P1 won the game ".to_upper()
		lose_label.text = "P2 lost the game ".to_upper()
		
	if winner == Constants.PLAYERS.P2:
		win_label.text = "P2 won the game ".to_upper()
		lose_label.text = "P1 lost the game ".to_upper()
	
	var win_tween = create_tween()
	win_tween.tween_property(win_label, "visible_ratio", 1.0, 0.75)
	win_tween.finished.connect(func():
		var lose_tween = create_tween()
		lose_tween.tween_property(lose_label, "visible_ratio", 1.0, 0.5)
		lose_tween.finished.connect(func(): $VBoxContainer/Button.modulate.a = 1.0)
	)
	
