extends Building

var backdoor_exit: Building 
var exit: bool = false

func _init() -> void:
	self.health = Constants.BACKDOOR_HEALTH
	self.cooldown = Constants.BACKDOOR_COOLDOWN
	self.decay = Constants.BACKDOOR_DECAY_DAMAGE
	self.target_enemy = Constants.BACKDOOR_TARGET_ENEMY
	self.action = ACTIONS.EFFECT_PERMANENT

func _ready() -> void:
	super()
	if not exit:
		var enemy_tower_list = GameState.p1_towers if player == Constants.PLAYERS.P2 else GameState.p2_towers
		var mirror_x = get_viewport_rect().size.x / 2
		var exit_pos: Vector2 = Vector2(2 * mirror_x - global_position.x, global_position.y)
		backdoor_exit = Constants.BACKDOOR_SPAWN_SCENE.instantiate()
		backdoor_exit.exit = true
		backdoor_exit.top_level = true
		backdoor_exit.global_position = exit_pos
		enemy_tower_list.append(self)
		add_child(backdoor_exit)
		print("made backdoor at: ", exit_pos)

func apply_effect(effect_target: Unit) -> void:
	if backdoor_exit:
		effect_target.global_position = backdoor_exit.global_position
		
