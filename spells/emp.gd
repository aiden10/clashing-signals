extends Area2D

var player: Constants.PLAYERS

func _ready() -> void:
	$Timer.wait_time = Constants.EMP_DURATION
	$Timer.start()
	$Timer.timeout.connect(cleanup)
	self.area_entered.connect(on_area_entered)
	self.area_exited.connect(on_area_exited)

func on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		if not parent.severed:
			Effects.add_ring(parent, Color(1.0, 1.0, 0.0))
			parent.sever()

func on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		if parent.severed:
			Effects.remove_ring(parent)
			parent.unsever()

func cleanup() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.finished.connect(queue_free)
