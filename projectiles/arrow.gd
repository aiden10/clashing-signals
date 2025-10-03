extends Projectile

func _init() -> void:
	self.damage = Constants.ARROW_DAMAGE
	self.speed = Constants.ARROW_SPEED
	self.pierce_limit = Constants.ARROW_PIERCE_LIMIT
