extends Area2D

var player: Constants.PLAYERS

func _ready() -> void:
	$Timer.wait_time = Constants.HP_EQUALIZER_DURATION
	$Timer.start()
	$Timer.timeout.connect(cleanup)
	self.area_entered.connect(on_area_entered)

func on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		parent.health = Constants.HP_EQUALIZER_HEALTH
		Effects.add_image(parent, name, Effects.IMAGES.HEART)

func cleanup() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.finished.connect(queue_free)
