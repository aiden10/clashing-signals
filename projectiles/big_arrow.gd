extends Projectile

func _init() -> void:
	self.damage = Constants.BIG_ARROW_DAMAGE
	self.speed = Constants.BIG_ARROW_SPEED
	self.pierce_limit = Constants.BIG_ARROW_PIERCE_LIMIT
