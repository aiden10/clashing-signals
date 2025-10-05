extends Unit

func _init() -> void:
	self.damage = Constants.GIANT_DAMAGE
	self.health = Constants.GIANT_HEALTH
	self.speed = Constants.GIANT_SPEED
	self.is_melee = Constants.GIANT_MELEE
	self.cooldown = Constants.GIANT_COOLDOWN
		
func attack() -> void:
	if is_instance_valid(self.target) and is_target_in_attack_range():
		self.target.take_damage(self.damage)
