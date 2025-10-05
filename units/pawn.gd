extends Unit

func _init() -> void:
	self.damage = Constants.PAWN_DAMAGE
	self.health = Constants.PAWN_HEALTH
	self.speed = Constants.PAWN_SPEED
	self.is_melee = Constants.PAWN_MELEE
	self.cooldown = Constants.PAWN_COOLDOWN
		
func attack() -> void:
	if is_instance_valid(self.target) and is_target_in_attack_range():
		self.target.take_damage(self.damage)
