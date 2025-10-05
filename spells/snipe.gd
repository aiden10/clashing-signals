extends Area2D

var player: Constants.PLAYERS
var damage: float

func _ready() -> void:
	damage = Constants.SNIPE_DAMAGE
	$Timer.wait_time = Constants.SNIPE_DURATION
	$Timer.start()
	$Timer.timeout.connect(cleanup)

func cleanup() -> void:
	for area in get_overlapping_areas():
		var parent = area.get_parent()
		if parent is Unit or parent is Building:
			if parent.player != player:
				parent.take_damage(damage)

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.finished.connect(queue_free)
