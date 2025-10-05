extends Area2D

var player: Constants.PLAYERS
var repaired: Array[Building] = []

func _ready() -> void:
	$Timer.wait_time = Constants.REPAIR_DURATION
	$Timer.start()
	$Timer.timeout.connect(cleanup)
	self.area_entered.connect(on_area_entered)

func on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Building and parent is not Tower:
		if parent.player == player:
			parent.take_decay_damage(parent.initial_hp * Constants.REPAIR_PERCENT)
			Effects.add_image(parent, name, Effects.IMAGES.WRENCH)
			repaired.append(parent)

func cleanup() -> void:
	for building in repaired:
		if is_instance_valid(building):
			Effects.remove_image(building, name)

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.finished.connect(queue_free)
