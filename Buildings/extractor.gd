extends Building


func _init() -> void:
	self.health = Constants.EXTRACTOR_HEALTH
	self.action = ACTIONS.EFFECT
	self.decay = Constants.EXTRACTOR_DECAY_DAMAGE
	self.cooldown = Constants.EXTRACTOR_COOLDOWN

func perform_action():
	GameState.game_instance.add_elixir_specific(self.player)
