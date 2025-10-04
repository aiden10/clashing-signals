extends Unit

func _init() -> void:
	self.damage = Constants.CANNON_DAMAGE
	self.health = Constants.CANNON_HEALTH
	self.speed = Constants.CANNON_SPEED
	self.is_melee = Constants.CANNON_MELEE
	self.cooldown = Constants.CANNON_COOLDOWN
	self.projectile_scene = Constants.CANNON_PROJECTILE

func attack() -> void:
	if is_instance_valid(self.target):
		if not self.target.is_in_group("backdoors"):
			shoot(target.position)
