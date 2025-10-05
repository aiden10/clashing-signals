extends Area2D

var player: Constants.PLAYERS
var to_clone: Array = []
var cloning_started: bool = false

func _ready() -> void:
	$Timer.wait_time = Constants.CLONE_DURATION
	$Timer.start()
	$Timer.one_shot = true
	$Timer.timeout.connect(cleanup)
	self.area_entered.connect(on_area_entered)

func on_area_entered(area: Area2D) -> void:
	if cloning_started:
		return
	var parent = area.get_parent()
	if parent is Unit:
		if parent.player == player and parent not in to_clone:
			to_clone.append(parent)

func cleanup() -> void:
	cloning_started = true
	monitoring = false
	monitorable = false
	for unit in to_clone:
		if not is_instance_valid(unit):
			continue
		var clone = unit.duplicate()
		clone.damage = unit.damage / Constants.CLONE_DEBUFF
		clone.health = unit.health / Constants.CLONE_DEBUFF
		clone.speed = unit.speed / Constants.CLONE_DEBUFF
		clone.player = unit.player
		clone.global_position += Vector2(randf_range(-15, 15), randf_range(-15, 15))
		Effects.add_image(clone, name, Effects.IMAGES.HELIX)
		get_tree().current_scene.add_child(clone)

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.finished.connect(queue_free)
