extends Area2D

var player: Constants.PLAYERS

var damage: float
var time_to_target: float
var own_tower_pos: Vector2 = Vector2.ZERO
var target_pos: Vector2 = Vector2.ZERO

func _init() -> void:
	damage = Constants.FIREBALL_DAMAGE

func _ready() -> void:
	if player == Constants.PLAYERS.P1:
		if GameState.p1_towers.size() != 0:
			own_tower_pos = GameState.p1_towers[0].position
	if player == Constants.PLAYERS.P2:
		if GameState.p2_towers.size() != 0:
			own_tower_pos = GameState.p2_towers[0].position
	self.monitoring = false

	target_pos = self.position
	self.position = own_tower_pos
	
	time_to_target = own_tower_pos.distance_to(target_pos)/Constants.FIREBALL_SPEED
	
	$Timer.wait_time = Constants.FIREBALL_DURATION
	$Timer.timeout.connect(cleanup)
	self.area_entered.connect(on_area_entered)
	
	var tween = get_tree().create_tween()
	tween.finished.connect(tween_finished)
	
	if player == Constants.PLAYERS.P1:
		tween.tween_property(self, "position", target_pos, time_to_target).from(own_tower_pos)
	
	elif player == Constants.PLAYERS.P2:
		tween.tween_property(self, "position", target_pos, time_to_target).from(own_tower_pos)

	var rotation_tween = create_tween()
	rotation_tween.tween_property($Sprite2D, "rotation", 90, 3.0)

func on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit or parent is Building:
		if parent.player != player:
			parent.take_damage(damage)

func tween_finished() -> void:
	self.monitoring = true
	$Timer.start()
	
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 0, 0.2)

func cleanup() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.2)
	tween.finished.connect(queue_free)
