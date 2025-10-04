extends CharacterBody2D
class_name Building

# effect_permanent uses a cooldown while effect_area is constant until unit leaves radius
enum ACTIONS { ATTACK, SPAWN, EFFECT_PERMANENT, EFFECT_AREA }

var player: Constants.PLAYERS
var health: float
var damage: float = 0.0
var cooldown: float = 0
var spawn_scene: PackedScene
var spawn_count: int = 0
var projectile_scene: PackedScene
var effect: String = ""
var target_enemy: bool = true
var target_friendly: bool = false
var target: Node2D
var action: ACTIONS
var decay: float = 0.0
var extends_signal: bool = false

var cooldown_timer: Timer
var signal_line: Line2D
var initial_hp: float

func _ready() -> void:
	initial_hp = health
	if cooldown != 0:
		cooldown_timer = Timer.new()
		cooldown_timer.wait_time = cooldown
		cooldown_timer.autostart = true
		cooldown_timer.timeout.connect(perform_action)
		add_child(cooldown_timer)

	signal_line = Line2D.new()
	signal_line.width = 2.0
	signal_line.top_level = true
	add_child(signal_line)

	if damage > 0:
		action = ACTIONS.ATTACK
	elif spawn_scene != null:
		action = ACTIONS.SPAWN
	elif effect != "":
		action = ACTIONS.EFFECT_PERMANENT

	if player == Constants.PLAYERS.P1:
		$Sprite2D.modulate = Color8(255, 0, 0)
		signal_line.default_color = Color8(255, 0, 0)
		collision_layer = 4
		collision_mask = 3
	else:
		$Sprite2D.modulate = Color8(0, 0, 255)
		signal_line.default_color = Color8(0, 0, 255)
		collision_layer = 3
		collision_mask = 4
	
	if player == Constants.PLAYERS.P1 and extends_signal:
		GameState.p1_towers.append(self)
	if player == Constants.PLAYERS.P2 and extends_signal:
		GameState.p2_towers.append(self)
	
	$DetectionRange.area_entered.connect(signal_buff)
	$DetectionRange.area_exited.connect(signal_debuff)

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
	if not target:
		return
	if projectile_scene:
		shoot()

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
		var parent = area.get_parent()
		if parent is Unit:
			if (target_enemy and parent.player != player) or (not target_enemy and parent.player == player):
				apply_effect(parent)
	update_line()

func apply_effect(effect_target: Unit):
	pass

func signal_buff(area: Area2D) -> void:
	if not extends_signal:
		return

	var parent = area.get_parent()
	if parent is Unit:
		if parent.player == self.player and not parent.severed:
			parent.damage *= Constants.SIGNAL_BUFF
			parent.speed *= Constants.SIGNAL_BUFF
			parent.cooldown /= Constants.SIGNAL_BUFF
			parent.attack_timer.wait_time = parent.cooldown

func signal_debuff(area: Area2D) -> void:
	if not extends_signal:
		return

	var parent = area.get_parent()
	if parent is Unit:
		if parent.player == self.player and not parent.severed:
			parent.damage /= Constants.SIGNAL_BUFF
			parent.speed /= Constants.SIGNAL_BUFF
			parent.cooldown *= Constants.SIGNAL_BUFF
			parent.attack_timer.wait_time = parent.cooldown
			
func shoot() -> void:
	if not is_instance_valid(target) or not is_target_in_attack_range(target):
		return
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.player = player
	projectile.damage = damage
	projectile.global_position = global_position
	projectile.target_position = target.global_position
	get_tree().current_scene.add_child(projectile)

func take_damage(damage_taken: float) -> void:
	health -= damage_taken
	Effects.spawn_hit_particle(global_position)
	if health > 0:
		modulate.a = float(health) / float(initial_hp)
	else:
		die()

func take_decay_damage(damage_taken: float) -> void:
	health -= damage_taken
	if health > 0:
		modulate.a = float(health) / float(initial_hp)
	else:
		die()

func die() -> void:
	if player == Constants.PLAYERS.P1:
		GameState.p1_towers.erase(self)
	else:
		GameState.p2_towers.erase(self)
	EventBus.building_destroyed.emit(self)
	queue_free()

func _physics_process(_delta: float) -> void:
	var t = get_target_in_range()
	update_line()
	if t:
		target = t

func update_line() -> void:
	signal_line.modulate.a = float(health) / float(initial_hp)
	signal_line.clear_points()
	signal_line.add_point(global_position)
	
	if extends_signal:
		for t in get_targets_in_range():
			if is_instance_valid(t):
				if t is Unit:
					if t.severed:
						continue

				signal_line.add_point(t.global_position)
				signal_line.add_point(global_position) 
	
	if not is_instance_valid(target):
		return
		
	if not is_target_in_attack_range(target):
		return
		
	if is_instance_valid(target):
		signal_line.add_point(target.global_position)
		signal_line.add_point(global_position)

func get_targets_in_range() -> Array[Node2D]:
	var targets: Array[Node2D] = []
	for area in $DetectionRange.get_overlapping_areas():
		var parent = area.get_parent()
		if ((parent is Unit or parent is Building) and parent.player == player and parent != self):
			targets.append(parent)

	return targets

func get_target_in_range() -> Node2D:
	var nearest_enemy = null
	var min_dist_sq = INF
	for area in $DetectionRange.get_overlapping_areas():
		var parent = area.get_parent()
		if ((parent is Unit or parent is Building)
			and ((parent.player != player and target_enemy)
			or (parent.player == player and target_friendly))
			and parent != self):
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
		if not is_instance_valid(tower) or tower == self:
			continue
		var dist_sq = global_position.distance_squared_to(tower.global_position)
		if dist_sq < min_dist_sq:
			min_dist_sq = dist_sq
			nearest = tower
	return nearest

func is_target_in_attack_range(atk_target: Node2D) -> bool:
	for area in $DetectionRange.get_overlapping_areas():
		if area.get_parent() == atk_target:
			return true
	
	return false
	
