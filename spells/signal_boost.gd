extends Area2D

var player: Constants.PLAYERS

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
			Effects.add_ring(parent)
			parent.damage *= Constants.SIGNAL_BUFF
			parent.speed *= Constants.SIGNAL_BUFF
			parent.cooldown /= Constants.SIGNAL_BUFF

func on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		if parent.player == self.player:
			Effects.remove_ring(parent)
			parent.damage /= Constants.SIGNAL_BUFF
			parent.speed /= Constants.SIGNAL_BUFF
			parent.cooldown *= Constants.SIGNAL_BUFF

func cleanup() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.finished.connect(queue_free)
