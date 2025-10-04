extends Building


func _init() -> void:
	
	self.health = Constants.SIGNAL_TOWER_HEALTH
	self.action = ACTIONS.EFFECT_AREA
	self.decay = Constants.SIGNAL_TOWER_DECAY_DAMAGE

func on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		if parent.player == self.player:
			Effects.add_ring(parent)
			parent.damage *= Constants.SIGNAL_BUFF
			parent.speed *= Constants.SIGNAL_BUFF
			parent.cooldown /= Constants.SIGNAL_BUFF
			
			take_decay_damage(0.5)

func on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		if parent.player == self.player:
			Effects.remove_ring(parent)
			parent.damage /= Constants.SIGNAL_BUFF
			parent.speed /= Constants.SIGNAL_BUFF
			parent.cooldown *= Constants.SIGNAL_BUFF
