extends Projectile

func _init() -> void:
	self.damage = Constants.CANNONBALL_DAMAGE
	self.speed = Constants.CANNONBALL_SPEED
	self.pierce_limit = Constants.CANNONBALL_PIERCE_LIMIT
