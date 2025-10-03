extends Node2D
class_name Projectile
var player: Constants.PLAYERS
var speed: float
var damage: float
var target_position: Vector2 = Vector2.ZERO
var pierce_limit: int
var hit_count: int = 0
var direction: Vector2 = Vector2.ZERO 

func _ready() -> void:
	for child in self.get_children():
		if child is Area2D:
			child.area_entered.connect(on_area_entered)
	
	var lifespan_timer: Timer = Timer.new()
	add_child(lifespan_timer)
	lifespan_timer.wait_time = 5
	lifespan_timer.start()
	lifespan_timer.timeout.connect(queue_free)
	
	if target_position != Vector2.ZERO:
		direction = (target_position - global_position).normalized()
		look_at(target_position)
	else:
		push_error("no target position set")
	
func _physics_process(delta: float) -> void:
	var velocity = direction * speed
	position += velocity * delta

func on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Tower or parent is Unit:
		if parent.player != self.player:
			parent.take_damage(self.damage)
			hit_count += 1
			if hit_count >= pierce_limit:
				queue_free()
