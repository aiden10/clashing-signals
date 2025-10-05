extends Building

var target_pos: Vector2

func _init() -> void:
	self.health = Constants.BALLISTA_HEALTH
	self.cooldown = Constants.BALLISTA_COOLDOWN
	self.damage = Constants.BALLISTA_DAMAGE
	self.projectile_scene = Constants.BALLISTA_PROJECTILE_SCENE
	self.decay = Constants.BALLISTA_DECAY_DAMAGE
	self.action = ACTIONS.ATTACK

func _ready() -> void:
	super()
	if self.player == Constants.PLAYERS.P1:
		target_pos = Vector2(global_position.x + 100, global_position.y)
	else:
		target_pos = Vector2(global_position.x - 100, global_position.y)
		$Sprite2D.flip_h = true

func attack() -> void:
	shoot(target_pos)
	
