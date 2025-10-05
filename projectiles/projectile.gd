extends Node2D

class_name Projectile

var player: Constants.PLAYERS
var speed: float
var damage: float
var target_position: Vector2 = Vector2.ZERO
var pierce_limit: int
var hit_count: int = 0
var direction: Vector2 = Vector2.ZERO 

var end_pos: Vector2 = Vector2.ZERO

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
	
	if player == Constants.PLAYERS.P1:
		modulate = Color(1, 0, 0)
	else:
		modulate = Color(0, 0, 1)
	
func _physics_process(delta: float) -> void:
	var velocity = direction * speed
	position += velocity * delta
	if end_pos != Vector2.LEFT and position.distance_squared_to(end_pos) > 100:
		on_destroy()
		
func on_destroy():
	pass

func on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Building or parent is Unit:
		if parent.player != self.player:
			if hit_count > pierce_limit:
				queue_free()
				return
			parent.take_damage(self.damage)
			hit_count += 1
			if hit_count >= pierce_limit:
				queue_free()
				
