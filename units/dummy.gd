extends Unit

func _init() -> void:
	self.damage = Constants.DUMMY_DAMAGE
	self.health = Constants.DUMMY_HEALTH
	self.speed = Constants.DUMMY_SPEED
	self.is_melee = Constants.DUMMY_MELEE
	self.cooldown = Constants.DUMMY_COOLDOWN

func attack() -> void:
	if is_instance_valid(self.target) and is_target_in_attack_range():
		self.target.take_damage(self.damage)
