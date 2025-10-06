extends Control

@export var logo: TextureRect
@export var start_button: Button
@export var fullscreen_button: TextureButton

func _ready() -> void:
	start_button.pressed.connect(func(): 
		GameStateManager.goto_scene(Constants.GAME_SCENES.DECK)
	)
	fullscreen_button.pressed.connect(func(): DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN))
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(logo, "modulate:a", 0.8, 2.0)
	tween.tween_property(logo, "modulate:a", 1.0, 2.0)
