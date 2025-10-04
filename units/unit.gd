extends CharacterBody2D
class_name Unit
var player: Constants.PLAYERS
var damage: float
var health: int
var speed: float
var target: Node2D
var is_melee: bool
var cooldown: float
var attack_timer: Timer
var projectile_scene: PackedScene
var signal_line: Line2D
var initial_hp: int 

var nav_agent: NavigationAgent2D

func _ready() -> void:
	attack_timer = Timer.new()
	attack_timer.wait_time = cooldown
	attack_timer.autostart = true
	attack_timer.timeout.connect(attack)
	add_child(attack_timer)
	
	signal_line = Line2D.new()
	add_child(signal_line)
	signal_line.top_level = true
	signal_line.width = 1.5
	
	initial_hp = self.health
	
	if self.player == Constants.PLAYERS.P1:
		self.modulate = Color8(512, 0, 0)
		signal_line.default_color = Color8(512, 0, 0)
	else:
		self.modulate = Color8(0, 0, 512)
		signal_line.default_color = Color8(0, 0, 512)
	
	## Prevents collision between friendly units but keeps collision with enemies
	var mask = 3 if self.player == Constants.PLAYERS.P1 else 4
	var col_layer = 4 if self.player == Constants.PLAYERS.P1 else 3
	self.collision_layer = col_layer
	self.collision_mask = mask
	
	## Putting this hardcoded node name in here reduces redundancy in child unit classes, but means that 
	## the detection Area2D must be named "DetectionRange"
	$DetectionRange.area_entered.connect(self.detection_range_entered)
	
	nav_agent = NavigationAgent2D.new()
	nav_agent.radius = $CollisionShape2D.shape.radius * 2
	add_child(nav_agent)

func detection_range_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if is_melee and parent is Unit:
		if parent.player != self.player:
			target = parent
			nav_agent.target_position = target.position

## Basically just an abstract function
func attack() -> void:
	pass

func shoot() -> void:
	if not is_instance_valid(self.target) or not is_target_in_attack_range():
		return
	var projectile: Projectile = self.projectile_scene.instantiate()
	projectile.player = self.player
	projectile.target_position = self.target.global_position
	projectile.global_position = self.global_position
	 ## I'm not sure if projectiles should keep their own damage, or get it from the shooter
	projectile.damage = self.damage
	get_tree().current_scene.add_child(projectile)

func take_damage(damage_taken: int) -> void:
	self.health -= damage_taken
	Effects.spawn_hit_particle(self.global_position)
	if self.health > 0:
		self.modulate.a = float(self.health) / float(initial_hp)
	else:
		die()

func die() -> void:
	EventBus.unit_died.emit()
	attack_timer.stop()
	queue_free()

func _physics_process(_delta: float) -> void:
	update_line()

	var nearest_enemy = get_nearest_enemy()
	if nearest_enemy:
		target = nearest_enemy
	elif not is_instance_valid(target):
		target = get_nearest_tower()
	
	if not is_instance_valid(target):
		self.velocity = Vector2.ZERO
		move_and_slide()
		return

	if target:
		nav_agent.target_position = target.global_position
	var target_in_range = is_target_in_attack_range()

	if target_in_range:
		self.velocity = Vector2.ZERO
	else:
		# NavigationAgent handles the path
		if nav_agent.is_navigation_finished():
			self.velocity = Vector2.ZERO
		else:
			var next_path_pos = nav_agent.get_next_path_position()
			var direction = (next_path_pos - global_position).normalized()
			self.velocity = direction * speed
			move_and_slide()

	look_at(target.global_position)


func update_line() -> void:
	self.signal_line.clear_points()
	self.signal_line.add_point(self.global_position)
	
	if is_instance_valid(self.target):
		self.signal_line.add_point(self.target.global_position)
		self.signal_line.add_point(self.global_position)
	
	var nearest_friendly_tower = get_nearest_tower(true)
	if nearest_friendly_tower:
		self.signal_line.add_point(nearest_friendly_tower.global_position)

	self.signal_line.modulate.a = float(self.health) / float(initial_hp)

func get_nearest_enemy() -> Node2D:
	var nearest_enemy = null
	var min_dist_sq = INF
	
	for area in $DetectionRange.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is Unit:
			if parent.player != self.player:
				var dist_sq = global_position.distance_squared_to(parent.global_position)
				if dist_sq < min_dist_sq:
					min_dist_sq = dist_sq
					nearest_enemy = parent
					
	return nearest_enemy

func get_nearest_tower(get_friendly: bool = false) -> Node2D:
	var min_dist_sq: float = INF
	var nearest: Node2D = null
	
	var towers_to_search: Array
	if get_friendly:
		towers_to_search = GameState.p1_towers if player == Constants.PLAYERS.P1 else GameState.p2_towers
	else:
		towers_to_search = GameState.p2_towers if player == Constants.PLAYERS.P1 else GameState.p1_towers
	
	for tower in towers_to_search:
		if not is_instance_valid(tower):
			continue
		var dist_sq = global_position.distance_squared_to(tower.global_position)
		if dist_sq < min_dist_sq:
			min_dist_sq = dist_sq
			nearest = tower
	
	return nearest

func is_target_in_attack_range() -> bool:
	if not is_instance_valid(self.target):
		return false
	
	for area in $AttackRange.get_overlapping_areas():
		var parent = area.get_parent()
		if parent == self.target:
			return true
	
	return false
