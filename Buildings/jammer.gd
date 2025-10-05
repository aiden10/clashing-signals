extends Building

func _init() -> void:
	self.health = Constants.JAMMER_TOWER_HEALTH
	self.action = ACTIONS.EFFECT_AREA
	self.decay = Constants.JAMMER_TOWER_DECAY_DAMAGE

func on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit and parent.player != self.player:
		if not parent.severed:
			Effects.add_ring(parent, name, Color(1.0, 1.0, 0.0))
			parent.sever()
			take_decay_damage(self.decay)
			print("taking decay", self.decay)

func on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		if parent.severed:
			Effects.remove_ring(parent, name)
			parent.unsever()
