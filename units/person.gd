extends Unit

func _init() -> void:
	self.damage = Constants.PERSON_DAMAGE
	self.health = Constants.PERSON_HEALTH
	self.speed = Constants.PERSON_SPEED
	self.is_melee = Constants.PERSON_MELEE
	self.cooldown = Constants.PERSON_COOLDOWN

func attack() -> void:
	if is_instance_valid(self.target) and is_target_in_attack_range():
		self.target.take_damage(self.damage)
