extends Unit

func _init() -> void:
	self.damage = Constants.ARCHER_DAMAGE
	self.health = Constants.ARCHER_HEALTH
	self.speed = Constants.ARCHER_SPEED
	self.is_melee = Constants.ARCHER_MELEE
	self.cooldown = Constants.ARCHER_COOLDOWN
	self.projectile_scene = Constants.ARCHER_PROJECTILE

func attack() -> void:
	if is_instance_valid(self.target):
		if not self.target.is_in_group("backdoors"):
			shoot()
