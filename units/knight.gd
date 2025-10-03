extends Unit

func _ready() -> void:
	super()
	$DetectionRange.area_entered.connect(self.detection_range_entered)
	if self.player == Constants.PLAYERS.P1:
		self.modulate = Color(255, 0, 0)
	else:
		self.modulate = Color(0, 0, 255)

func _init() -> void:
	self.damage = Constants.KNIGHT_DAMAGE
	self.health = Constants.KNIGHT_HEALTH
	self.speed = Constants.KNIGHT_SPEED
	self.is_melee = Constants.KNIGHT_MELEE
	self.cooldown = Constants.KNIGHT_COOLDOWN
		
func attack() -> void:
	var nearest_enemy = null
	var min_dist_sq = INF
	
	for area in $AttackRange.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is Unit or parent is Tower:
			if parent.player != self.player:
				var dist_sq = global_position.distance_squared_to(parent.global_position)
				if dist_sq < min_dist_sq:
					min_dist_sq = dist_sq
					nearest_enemy = parent
	
	if nearest_enemy:
		nearest_enemy.take_damage(self.damage)
