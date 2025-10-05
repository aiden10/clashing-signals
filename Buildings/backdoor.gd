extends Building

var backdoor_exit: Building 
var exit: bool = false

func _init() -> void:
	self.health = Constants.BACKDOOR_HEALTH
	self.cooldown = Constants.BACKDOOR_COOLDOWN
	self.decay = Constants.BACKDOOR_DECAY_DAMAGE
	self.target_enemy = Constants.BACKDOOR_TARGET_ENEMY
	self.action = ACTIONS.EFFECT

func _ready() -> void:
	super()
	if not exit:
		var mirror_x = get_viewport_rect().size.x / 2
		var exit_pos: Vector2 = Vector2(2 * mirror_x - global_position.x, global_position.y)
		backdoor_exit = Constants.BACKDOOR_SPAWN_SCENE.instantiate()
		backdoor_exit.exit = true
		backdoor_exit.top_level = true
		backdoor_exit.global_position = exit_pos
		add_child(backdoor_exit)

func apply_effect(effect_target: Unit) -> void:
	if backdoor_exit:
		effect_target.global_position = backdoor_exit.global_position + Vector2(randi_range(-10, 10), randi_range(-10, 10))
		
