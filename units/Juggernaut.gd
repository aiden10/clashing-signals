extends Unit

func _init() -> void:
	self.damage = Constants.JUGGERNAUT_DAMAGE
	self.health = Constants.JUGGERNAUT_HEALTH
	self.speed = Constants.JUGGERNAUT_SPEED
	self.is_melee = Constants.JUGGERNAUT_MELEE
	self.cooldown = Constants.JUGGERNAUT_COOLDOWN
		
func attack() -> void:
	if is_instance_valid(self.target) and is_target_in_attack_range() and !self.severed:
		self.target.take_damage(self.damage)

func signal_buff() -> void:
	super()
	if connection_count > 0:
		Effects.remove_image(self, name)
		disabled = false

func signal_unbuff() -> void:
	super()
	if connection_count == 0:
		Effects.add_image(self, name, Effects.IMAGES.WARNING)
		disabled = true

func severed_changed() -> void:
	if severed:
		Effects.add_image(self, name, Effects.IMAGES.WARNING)
		disabled = true
	else:
		Effects.remove_image(self, name)
		disabled = false
