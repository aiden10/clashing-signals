extends Unit

func _init() -> void:
	self.damage = Constants.KNIGHT_DAMAGE
	self.health = Constants.KNIGHT_HEALTH
	self.speed = Constants.KNIGHT_SPEED
	self.is_melee = Constants.KNIGHT_MELEE
	self.cooldown = Constants.KNIGHT_COOLDOWN
		
func attack() -> void:
	if is_instance_valid(self.target) and is_target_in_attack_range():
		self.target.take_damage(self.damage)
