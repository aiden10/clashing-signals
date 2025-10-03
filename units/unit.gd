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

func _ready() -> void:
	attack_timer = Timer.new()
	attack_timer.wait_time = cooldown
	attack_timer.autostart = true
	attack_timer.timeout.connect(attack)
	add_child(attack_timer)

func detection_range_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if is_melee and parent is Unit:
		if parent.player != self.player:
			target = parent

func attack() -> void:
	pass

func take_damage(damage_taken: int) -> void:
	health -= damage_taken
	if health <= 0:
		die()

func die() -> void:
	EventBus.unit_died.emit()
	attack_timer.stop()
	queue_free()

func _physics_process(_delta: float) -> void:
	# If there are no enemy units in detection range, towers will be prioritized
	if not self.target:
		var nearest_tower = get_nearest_tower()
		if nearest_tower:
			self.target = nearest_tower
	if is_instance_valid(self.target):
		var direction = (self.target.global_position - global_position).normalized()
		self.velocity = self.speed * direction
		
		move_and_slide()
		look_at(self.target.global_position)

func get_nearest_tower() -> Node2D:
	var min_dist_sq: float = INF
	var nearest: Node2D = null
	
	if player == Constants.PLAYERS.P1:
		for tower in TowersState.p2_towers:
			if not is_instance_valid(tower):
				continue
			var dist_sq = global_position.distance_squared_to(tower.global_position)
			if dist_sq < min_dist_sq:
				min_dist_sq = dist_sq
				nearest = tower
	else:
		for tower in TowersState.p1_towers:
			if not is_instance_valid(tower):
				continue
			var dist_sq = global_position.distance_squared_to(tower.global_position)
			if dist_sq < min_dist_sq:
				min_dist_sq = dist_sq
				nearest = tower
	
	return nearest
