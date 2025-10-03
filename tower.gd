# tower.gd
extends Node2D
class_name Tower
var health: float
var cooldown: float
@export var player: Constants.PLAYERS
var projectile_scene: PackedScene
var target: Unit
@onready var hp_bar: ProgressBar = $HPBar

func _ready() -> void:
	if player == Constants.PLAYERS.P1:
		TowersState.p1_towers.append(self)
	else:
		TowersState.p2_towers.append(self)
	
	var attack_timer = Timer.new()
	attack_timer.wait_time = cooldown
	attack_timer.autostart = true
	attack_timer.timeout.connect(shoot)
	add_child(attack_timer)
	
	hp_bar.max_value = self.health
	hp_bar.value = self.health

func _init() -> void:
	self.health = Constants.TOWER_HEALTH
	self.cooldown = Constants.TOWER_COOLDOWN
	self.projectile_scene = Constants.TOWER_PROJECTILE

func get_nearest_target() -> Unit:
	var nearest_target: Unit = null
	var min_dist_sq = INF
	
	for area in $AttackRange.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is Unit:
			if parent.player != self.player and is_instance_valid(parent):
				var dist_sq = global_position.distance_squared_to(parent.global_position)
				if dist_sq < min_dist_sq:
					min_dist_sq = dist_sq
					nearest_target = parent
	
	return nearest_target

func shoot() -> void:
	self.target = get_nearest_target()
	
	if self.target and is_instance_valid(self.target):
		var projectile: Projectile = self.projectile_scene.instantiate()
		projectile.player = self.player
		projectile.target_position = self.target.global_position
		projectile.global_position = self.global_position
		get_tree().current_scene.add_child(projectile)

func take_damage(damage_taken: float) -> void:
	health -= damage_taken
	hp_bar.value = self.health
	if health <= 0:
		die()

func die() -> void:
	if player == Constants.PLAYERS.P1:
		TowersState.p1_towers.erase(self)
	else:
		TowersState.p2_towers.erase(self)
	EventBus.tower_destroyed.emit()
	queue_free()
