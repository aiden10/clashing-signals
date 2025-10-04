extends Unit

func _init() -> void:
	self.damage = Constants.JUGGERNAUT_DAMAGE
	self.health = Constants.JUGGERNAUT_HEALTH
	self.speed = Constants.JUGGERNAUT_SPEED
	self.is_melee = Constants.JUGGERNAUT_MELEE
	self.cooldown = Constants.JUGGERNAUT_COOLDOWN
		
func attack() -> void:
	if is_instance_valid(self.target) and is_target_in_attack_range() and !self.severed:
		self.target.take_damage(self.damage)

func severed_changed(severed: bool) -> void:
	if severed:
		self.speed = 0
		self.health /= 30
	else:
		self.speed = Constants.JUGGERNAUT_SPEED
