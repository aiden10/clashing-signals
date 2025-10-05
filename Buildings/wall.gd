extends Building

func _init() -> void:
	self.health = Constants.WALL_HEALTH
	self.action = ACTIONS.EFFECT
	self.decay = Constants.WALL_DECAY_DAMAGE
	self.cooldown = Constants.WALL_COOLDOWN
