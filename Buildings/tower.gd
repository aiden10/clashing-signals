
extends Building

func _ready() -> void:
	super()
	if player == Constants.PLAYERS.P1:
		GameState.p1_towers.append(self)
	else:
		GameState.p2_towers.append(self)
		
	for child in get_children():
		if "SignalRange" in child.name and child is Area2D:
			child.area_entered.connect(signal_buff)
			child.area_entered.connect(signal_debuff)

func _init() -> void:
	self.health = Constants.TOWER_HEALTH
	self.cooldown = Constants.TOWER_COOLDOWN
	self.action = ACTIONS.ATTACK
	self.projectile_scene = Constants.TOWER_PROJECTILE
	self.decay = 0
	self.extends_signal = true

func signal_buff(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		if parent.player == self.player:
			parent.damage *= Constants.SIGNAL_BUFF
			parent.speed *= Constants.SIGNAL_BUFF
			parent.cooldown /= Constants.SIGNAL_BUFF

func signal_debuff(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		if parent.player == self.player:
			parent.damage /= Constants.SIGNAL_BUFF
			parent.speed /= Constants.SIGNAL_BUFF
			parent.cooldown *= Constants.SIGNAL_BUFF

func die() -> void:
	if player == Constants.PLAYERS.P1:
		GameState.p1_towers.erase(self)
	else:
		GameState.p2_towers.erase(self)
	EventBus.tower_destroyed.emit()
	queue_free()
	
