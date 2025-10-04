extends CharacterBody2D
class_name Building

# effect_permanent uses a cooldown while effect_area is constant until unit leaves radius
enum ACTIONS { ATTACK, SPAWN, EFFECT_PERMANENT, EFFECT_AREA }

var player: Constants.PLAYERS
var health: int
var damage: float = 0.0
var range: float = 128.0
var cooldown: float = 1.0
var spawn_scene: PackedScene
var spawn_count: int = 0
var projectile_scene: PackedScene
var effect: String = ""
var target_enemy: bool = true
var target: Node2D
var action: ACTIONS
var decay: float = 0.0

var cooldown_timer: Timer
var signal_line: Line2D
var initial_hp: int


func _ready() -> void:
	initial_hp = health

	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = cooldown
	cooldown_timer.autostart = true
	cooldown_timer.timeout.connect(perform_action)
	add_child(cooldown_timer)

	signal_line = Line2D.new()
	signal_line.width = 1.5
	signal_line.top_level = true
	add_child(signal_line)

	if damage > 0:
		action = ACTIONS.ATTACK
	elif spawn_scene != null:
		action = ACTIONS.SPAWN
	elif effect != "":
		action = ACTIONS.EFFECT_PERMANENT

	if player == Constants.PLAYERS.P1:
		modulate = Color8(255, 0, 0)
		signal_line.default_color = Color8(255, 0, 0)
	else:
		modulate = Color8(0, 0, 255)
		signal_line.default_color = Color8(0, 0, 255)

	if player == Constants.PLAYERS.P1:
		GameState.p1_towers.append(self)
	else:
		GameState.p2_towers.append(self)

	if player == Constants.PLAYERS.P1:
		collision_layer = 4
		collision_mask = 3
	else:
		collision_layer = 3
		collision_mask = 4
		
	


func perform_action():
	match action:
		ACTIONS.ATTACK:
			attack()
		ACTIONS.SPAWN:
			spawn_unit()
		ACTIONS.EFFECT_PERMANENT:
			give_effect()
	take_decay_damage(decay)

func attack():
	var enemy = get_enemy_in_range()
	if not enemy:
		return
	if projectile_scene:
		target = enemy
		shoot()
	else:
		enemy.take_damage(damage)
		Effects.spawn_hit_particle(enemy.global_position)
	update_line()


func spawn_unit():
	if not spawn_scene:
		return
	for i in range(spawn_count):
		var unit: Unit = spawn_scene.instantiate()
		unit.player = player
		unit.global_position = global_position + Vector2(randi_range(-20, 20), randi_range(-20, 20))
		get_tree().current_scene.add_child(unit)
	update_line()


func give_effect():
	for area in $DetectionRange.get_overlapping_areas():
		var target = area.get_parent()
		if target is Unit:
			if (target_enemy and target.player != player) or (not target_enemy and target.player == player):
				apply_effect(target)
	update_line()

func apply_effect(target: Unit):
	pass


func shoot() -> void:
	if not is_instance_valid(target) or not is_target_in_attack_range(target):
		return
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.player = player
	projectile.damage = damage
	projectile.global_position = global_position
	projectile.target_position = target.global_position
	get_tree().current_scene.add_child(projectile)


func take_damage(damage_taken: int) -> void:
	health -= damage_taken
	Effects.spawn_hit_particle(global_position)
	if health > 0:
		modulate.a = float(health) / float(initial_hp)
	else:
		die()

func take_decay_damage(damage_taken: int) -> void:
	health -= damage_taken
	if health > 0:
		modulate.a = float(health) / float(initial_hp)
	else:
		die()


func die() -> void:
	cooldown_timer.stop()
	if player == Constants.PLAYERS.P1:
		GameState.p1_towers.erase(self)
	else:
		GameState.p2_towers.erase(self)
	EventBus.building_destroyed.emit(self)
	queue_free()


func _physics_process(_delta: float) -> void:
	var enemy = get_enemy_in_range()
	update_line()
	if enemy:
		target = enemy
		look_at(target.global_position)


func update_line() -> void:
	signal_line.clear_points()
	signal_line.add_point(global_position)
	if is_instance_valid(target):
		signal_line.add_point(target.global_position)
		signal_line.add_point(global_position)
	signal_line.modulate.a = float(health) / float(initial_hp)


func get_enemy_in_range() -> Node2D:
	var nearest_enemy = null
	var min_dist_sq = INF
	for area in $DetectionRange.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is Unit and parent.player != player:
			var dist_sq = global_position.distance_squared_to(parent.global_position)
			if dist_sq < min_dist_sq:
				min_dist_sq = dist_sq
				nearest_enemy = parent
	return nearest_enemy


func get_nearest_tower(get_friendly: bool = false) -> Node2D:
	var min_dist_sq: float = INF
	var nearest: Node2D = null
	var towers_to_search: Array = (
		GameState.p1_towers if get_friendly and player == Constants.PLAYERS.P1 else
		GameState.p2_towers if get_friendly else
		GameState.p2_towers if player == Constants.PLAYERS.P1 else
		GameState.p1_towers
	)
	for tower in towers_to_search:
		if not is_instance_valid(tower):
			continue
		var dist_sq = global_position.distance_squared_to(tower.global_position)
		if dist_sq < min_dist_sq:
			min_dist_sq = dist_sq
			nearest = tower
	return nearest


func is_target_in_attack_range(target: Node2D) -> bool:
	return is_instance_valid(target) and global_position.distance_squared_to(target.global_position) <= range * range
