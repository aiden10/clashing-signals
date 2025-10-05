extends Area2D

var player: Constants.PLAYERS
var affected_areas: Array[Area2D] = []

func _ready() -> void:
	$Timer.wait_time = Constants.SIGNAL_BOOST_DURATION
	$Timer.start()
	$Timer.timeout.connect(cleanup)
	self.area_entered.connect(on_area_entered)
	self.area_exited.connect(on_area_exited)

func on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		if parent.player == self.player:
			affected_areas.append(area)
			Effects.add_image(parent, name, Effects.IMAGES.RING, Color(0.29, 0.949, 0.384, 1.0))
			parent.signal_buff()

func on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		if parent.player == self.player:
			Effects.remove_image(parent, name)
			parent.signal_unbuff()

func cleanup() -> void:
	for area in get_overlapping_areas() + affected_areas:
		if is_instance_valid(area):
			var parent = area.get_parent()
			if parent is Unit:
				Effects.remove_image(parent, name)

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.finished.connect(queue_free)
