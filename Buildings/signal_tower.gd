extends Building

func _init() -> void:
	self.health = Constants.SIGNAL_TOWER_HEALTH
	self.action = ACTIONS.EFFECT_AREA
	self.extends_signal = true
	self.decay = Constants.SIGNAL_TOWER_DECAY_DAMAGE

func on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		if parent.player == self.player:
			Effects.add_ring(parent, name)
			parent.signal_buff()
			
			take_decay_damage(0.5) 

func on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		if parent.player == self.player:
			Effects.remove_ring(parent, name)
			parent.signal_unbuff()
