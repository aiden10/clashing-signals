
extends Building

func _ready() -> void:
	super()
	if player == Constants.PLAYERS.P1:
		GameState.p1_towers.append(self)
	else:
		GameState.p2_towers.append(self)

func _init() -> void:
	self.health = Constants.TOWER_HEALTH
	self.cooldown = Constants.TOWER_COOLDOWN
	self.damage = Constants.TOWER_DAMAGE
	self.action = ACTIONS.ATTACK
	self.projectile_scene = Constants.TOWER_PROJECTILE
	self.decay = 0
	self.extends_signal = true

func die() -> void:
	if player == Constants.PLAYERS.P1:
		GameState.p1_towers.erase(self)
	else:
		GameState.p2_towers.erase(self)
	EventBus.tower_destroyed.emit()
	queue_free()
	
