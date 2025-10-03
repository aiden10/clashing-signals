extends Node2D

class_name Projectile

var player: Constants.PLAYERS
var speed: float
var damage: float
var target_position: Vector2 = Vector2.ZERO
var pierce_limit: int
var hit_count: int = 0

func _ready() -> void:
	for child in self.get_children():
		if child is Area2D:
			child.area_entered.connect(on_area_entered)

func _physics_process(delta: float) -> void:
	if target_position == Vector2.ZERO:
		push_error("no target position set")
	var direction = (self.target_position - self.global_position).normalized()
	var velocity = direction * self.speed
	self.position += velocity * delta
	look_at(self.target_position)

func on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Tower or parent is Unit:
		if parent.player != self.player:
			parent.take_damage(self.damage)
			self.hit_count += 1
			if self.hit_count >= self.pierce_limit:
				queue_free()
		
