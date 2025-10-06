extends Control

@export var exit_button: Button
@export var music_slider: HSlider
@export var sound_slider: HSlider
@export var fullscreen_button: TextureButton

func _ready() -> void:
	EventBus.pause_pressed.connect(func():
		show()
	)
	exit_button.pressed.connect(func(): 
		get_tree().paused = false
		GameStateManager.goto_scene(Constants.GAME_SCENES.DECK)
	)
	music_slider.drag_ended.connect(func(_changed: bool): 
		AudioManager.music_level = music_slider.value
		AudioManager.set_master_volume()
		EventBus.card_selected.emit()
	)
	sound_slider.drag_ended.connect(func(_changed: bool): 
		AudioManager.sound_level = sound_slider.value
		AudioManager.set_master_volume()
		EventBus.card_selected.emit()
	)
	
	fullscreen_button.pressed.connect(func(): DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN))

	music_slider.value = AudioManager.music_level
	sound_slider.value = AudioManager.sound_level

func _input(event):
	if event is InputEventKey and not Input.is_action_pressed("pause"):
		if event.pressed:
			self.hide()
			EventBus.unpaused.emit()
			get_tree().paused = false
