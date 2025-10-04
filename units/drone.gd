extends Unit

func _init() -> void:
	self.damage = Constants.DRONE_DAMAGE
	self.health = Constants.DRONE_HEALTH
	self.speed = Constants.DRONE_SPEED
	self.is_melee = Constants.DRONE_MELEE
	self.cooldown = Constants.DRONE_COOLDOWN
		
func attack() -> void:
	if is_instance_valid(self.target) and is_target_in_attack_range():
		self.target.take_damage(self.damage)
