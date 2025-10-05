extends CharacterBody2D
class_name Unit
var player: Constants.PLAYERS
var health: float

var percentage_damage_mod: float
var percentage_speed_mod: float
var cooldown_mult: float

var cooldown: float
var damage: float
var speed: float

var target: Node2D
var is_melee: bool
var attack_timer: Timer
var projectile_scene: PackedScene
var signal_line: Line2D
var initial_hp: float
var severed: bool = false
var target_friendly: bool = false
var nav_agent: NavigationAgent2D
var friendly_signals: int
var opposing_signals: int
var connection_count: int = 0
var disabled: bool = false

func _ready() -> void:
	## Current cooldown/damage/speed are set in subclasses, and base is updated here.
	self.percentage_damage_mod = 0
	self.percentage_speed_mod = 0
	self.cooldown_mult = 1
	
	attack_timer = Timer.new()
	attack_timer.wait_time = cooldown
	attack_timer.autostart = true
	attack_timer.timeout.connect(attack)
	add_child(attack_timer)
	
	signal_line = Line2D.new()
	add_child(signal_line)
	signal_line.top_level = true
	signal_line.width = 2.0
	
	initial_hp = self.health
	
	if self.player == Constants.PLAYERS.P1:
		$Sprite2D.self_modulate = Color8(512, 0, 0)
		signal_line.default_color = Color8(512, 0, 0)
	else:
		$Sprite2D.self_modulate = Color8(0, 0, 512)
		signal_line.default_color = Color8(0, 0, 512)
	
	## Prevents collision between friendly units but keeps collision with enemies
	var mask = 3 if self.player == Constants.PLAYERS.P1 else 4
	var col_layer = 4 if self.player == Constants.PLAYERS.P1 else 3
	self.collision_layer = col_layer
	self.collision_mask = mask
	
	nav_agent = NavigationAgent2D.new()
	nav_agent.radius = $CollisionShape2D.shape.radius * 2
	add_child(nav_agent)

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
	projectile.damage = calc_damage()
	get_tree().current_scene.add_child(projectile)

func sever() -> void:
	self.damage /= Constants.SEVER_DEBUFF
	self.speed /= Constants.SEVER_DEBUFF
	self.cooldown_mult *= Constants.SEVER_DEBUFF
	self.severed = true
	severed_changed()

func unsever() -> void:
	self.damage *= Constants.SEVER_DEBUFF
	self.speed *= Constants.SEVER_DEBUFF
	self.cooldown_mult /= Constants.SEVER_DEBUFF
	attack_timer.wait_time = self.cooldown
	self.severed = false
	severed_changed()

func calc_damage() -> float:
	return max(0, damage * (1 + percentage_damage_mod));

func take_damage(damage_taken: float) -> void:
	self.health -= damage_taken
	if health > initial_hp:
		print("unit ", self, " got overhealthed to ", health, "/", initial_hp)
		health = initial_hp
	
	EventBus.damage_taken.emit()
	Effects.spawn_hit_particle(self.global_position)
	if self.health > 0:
		self.modulate.a = 0.25 + 0.75 * float(self.health) / float(initial_hp)
	else:
		die()

func die() -> void:
	for area in $DetectionRange.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is Unit:
			Effects.remove_image(parent, name)

	EventBus.unit_died.emit()
	attack_timer.stop()
	queue_free()

func _physics_process(delta: float) -> void:
	update_line()
	if disabled:
		return

	var nearest_enemy = get_nearest_enemy()
	var nearest_tower = get_nearest_tower()
	var enemy_dist = INF
	var tower_dist = INF
	
	self.attack_timer.wait_time = self.cooldown * self.cooldown_mult
	
	if nearest_enemy and is_instance_valid(nearest_enemy):
		enemy_dist = global_position.distance_squared_to(nearest_enemy.global_position)
	if nearest_tower and is_instance_valid(nearest_tower):
		tower_dist = global_position.distance_squared_to(nearest_tower.global_position)
	
	if enemy_dist < tower_dist:
		target = nearest_enemy
	else:
		target = nearest_tower
		
	if not is_instance_valid(target):
		self.velocity = Vector2.ZERO
		move_and_slide()
		return

	if target:
		nav_agent.target_position = target.global_position
	var target_in_range = is_target_in_attack_range()

	if target_in_range and not target.is_in_group("backdoors"):
		self.velocity = Vector2.ZERO
	else:
		# NavigationAgent handles the path
		if nav_agent.is_navigation_finished():
			self.velocity = Vector2.ZERO
		else:
			var next_path_pos = nav_agent.get_next_path_position()
			var direction = (next_path_pos - global_position).normalized()
			self.velocity = direction * speed * (1 + percentage_speed_mod)  
			apply_separation_force(delta)
			move_and_slide()
	
	if target.global_position.x > global_position.x:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false

func apply_separation_force(delta: float) -> void:
	for area in $DetectionRange.get_overlapping_areas():
		var other = area.get_parent()
		if other == self:
			continue
		if not (other is Unit):
			continue
		if other.player != player:
			continue

		var diff = global_position - other.global_position
		var dist = diff.length()
		if dist > 0 and dist < Constants.MIN_DISTANCE:
			var push_dir = diff.normalized()
			var strength = (Constants.MIN_DISTANCE - dist) / Constants.MIN_DISTANCE
			velocity += push_dir * Constants.PUSH_STRENGTH * strength * delta

func update_line() -> void:
	self.signal_line.modulate.a = float(self.health) / float(initial_hp)
	self.signal_line.clear_points()
	
	if not is_target_in_attack_range():
		return

	self.signal_line.clear_points()
	#self.signal_line.add_point(self.global_position)
	
	if is_instance_valid(self.target):
		self.signal_line.add_point(self.target.global_position)
		self.signal_line.add_point(self.global_position)

func get_nearest_enemy() -> Node2D:
	var nearest: Node2D = null
	var min_dist_sq := INF

	for area in $DetectionRange.get_overlapping_areas():
		var parent = area.get_parent()
		if not (parent is Unit or parent is Building):
			continue
		
		if parent == self:
			continue
		
		if target_friendly:
			if not (parent is Unit and parent.player == self.player):
				continue
		else:
			if parent.player == self.player and not parent.is_in_group("backdoors"):
				continue

		if parent.is_in_group("backdoors"):
			if parent.exit or not parent.backdoor_exit:
				continue

		var dist_sq = global_position.distance_squared_to(parent.global_position)
		if dist_sq < min_dist_sq:
			min_dist_sq = dist_sq
			nearest = parent

	return nearest

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

func severed_changed() -> void:
	pass
	
func signal_buff() -> void:
	self.percentage_damage_mod += Constants.SIGNAL_DAMAGE_BUFF
	self.percentage_speed_mod += Constants.SIGNAL_SPEED_BUFF
	self.cooldown_mult *= 1 - Constants.SIGNAL_COOLDOWN_BUFF
	self.connection_count += 1
	#print(self, "'s new mods: ", percentage_damage_mod, ", ", percentage_speed_mod, ", ", cooldown_mult)

func signal_unbuff() -> void:
	self.percentage_damage_mod -= Constants.SIGNAL_DAMAGE_BUFF
	self.percentage_speed_mod -= Constants.SIGNAL_SPEED_BUFF
	self.cooldown_mult /= 1 - Constants.SIGNAL_COOLDOWN_BUFF
	self.connection_count -= 1
	#print(self, "'s new mods: ", percentage_damage_mod, ", ", percentage_speed_mod, ", ", cooldown_mult)
