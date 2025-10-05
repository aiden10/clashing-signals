extends Building

func _init() -> void:
	self.health = Constants.HOSPITAL_HEALTH
	self.cooldown = Constants.HOSPITAL_COOLDOWN
	self.spawn_scene = Constants.HOSPITAL_SPAWN_SCENE
	self.spawn_count = Constants.HOSPITAL_SPAWN_COUNT
	self.decay = Constants.HOSPITAL_DECAY_DAMAGE
	self.action = ACTIONS.SPAWN

func spawn_unit() -> void:
	for i in range(spawn_count):
		var unit: Unit = spawn_scene.instantiate()
		unit.player = player
		unit.global_position = global_position + Vector2(randi_range(-25, 25), randi_range(-25, 25))
		get_tree().current_scene.add_child(unit)
