extends Unit

func _init() -> void:
	self.damage = Constants.POCKET_WIFI_DAMAGE
	self.health = Constants.POCKET_WIFI_HEALTH
	self.speed = Constants.POCKET_WIFI_SPEED
	self.is_melee = Constants.POCKET_WIFI_MELEE
	self.cooldown = Constants.POCKET_WIFI_COOLDOWN
	self.target_friendly = true

func _ready() -> void:
	super()
	$DetectionRange.area_entered.connect(on_area_entered)
	$DetectionRange.area_exited.connect(on_area_exited)

func attack() -> void:
	if is_instance_valid(self.target) and is_target_in_attack_range() and self.target.player != self.player:
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

func on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		if parent.player == self.player and not parent.severed and parent != self:
			Effects.add_image(parent, name, Effects.IMAGES.SIGNAL, Color(1, 1, 1, 0.35))
			parent.signal_buff()

func on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Unit:
		if parent.player == self.player and not parent.severed and parent != self:
			Effects.remove_image(parent, name)
			parent.signal_unbuff()
