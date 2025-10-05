extends Node

class_name Player

var player: Constants.PLAYERS
var hand: Hand
var deck: Deck
var cursor: CharacterBody2D
var elixir: int = 100
var can_place: bool = true
var action_timer: Timer
var draw_timer: Timer 
var on_own_side: bool = true

func _ready() -> void:
	EventBus.elixir_updated.emit()
	
	if self.player == Constants.PLAYERS.P1:
		GameState.p1 = self
	if self.player == Constants.PLAYERS.P2:
		GameState.p2 = self

	self.hand = Hand.new()
	self.hand.player = self.player
	for i in range(self.hand.max_size):
		hand.add_card(self.deck.draw_card())
	
	action_timer = Timer.new()
	action_timer.wait_time = Constants.ACTION_COOLDOWN
	action_timer.timeout.connect(func(): can_place = true)
	action_timer.one_shot = true
	add_child(action_timer)

	draw_timer = Timer.new()
	draw_timer.wait_time = Constants.DRAW_COOLDOWN
	draw_timer.timeout.connect(draw_card)
	draw_timer.one_shot = true
	add_child(draw_timer)
	
	cursor.switched_side.connect(_on_switched_sides)

func _on_switched_sides() -> void:
	on_own_side = !on_own_side

func _physics_process(delta: float) -> void:
	var prefix = "p1_" if (player == Constants.PLAYERS.P1) else "p2_"
	var direction := Vector2.ZERO
	if Input.is_action_pressed(prefix + "up"):
		direction.y -= 1
	if Input.is_action_pressed(prefix + "down"):
		direction.y += 1
	if Input.is_action_pressed(prefix + "left"):
		direction.x -= 1
	if Input.is_action_pressed(prefix + "right"):
		direction.x += 1
	if Input.is_action_just_pressed(prefix + "select_next"):
		hand.next_card()
	if Input.is_action_just_pressed(prefix + "select_prev"):
		hand.prev_card()
	if Input.is_action_pressed(prefix + "use") and can_place:
		use_selected_card()
		can_place = false
		action_timer.start()

	if direction != Vector2.ZERO:
		self.cursor.move_and_collide(direction.normalized() * self.cursor.speed * delta)

func draw_card() -> void:
	if self.hand.cards.size() >= Constants.MAX_HAND_SIZE:
		return
		
	var new_card = self.deck.draw_card()
	self.hand.cards.append(new_card)
	EventBus.hand_updated.emit(self.player)
	
	if self.hand.cards.size() < Constants.MAX_HAND_SIZE:
		draw_timer.start()

func use_selected_card():
	var card = self.hand.get_selected()
	if not card:
		EventBus.invalid_action.emit()
		return
		
	if card.type != Constants.CARD_TYPES.SPELL && !on_own_side:
		EventBus.invalid_action.emit()
		return
		
	if card.cost > self.elixir:
		EventBus.invalid_action.emit()
		return
	self.elixir -= card.cost
	EventBus.elixir_updated.emit()
	
	if card.type == Constants.CARD_TYPES.UNIT:
		for i in range(card.count):
			var unit = card.scene.instantiate()
			unit.global_position = cursor.global_position + Vector2(randi_range(-25, 25), randi_range(-25, 25))
			unit.player = self.player
			get_tree().current_scene.add_child(unit)

	elif card.type == Constants.CARD_TYPES.SPELL:
		var spell = card.scene.instantiate()
		spell.global_position = cursor.global_position
		spell.player = self.player
		get_tree().current_scene.add_child(spell)
	
	if card.type == Constants.CARD_TYPES.BUILDING:
		var building = card.scene.instantiate()
		building.global_position = cursor.global_position
		building.player = self.player
		get_tree().current_scene.add_child(building)
	
	self.hand.cards.pop_at(self.hand.selected_index)
	if self.hand.selected_index > 0:
		self.hand.selected_index -= 1
	EventBus.hand_updated.emit(self.player)
	
	if self.hand.cards.size() < Constants.MAX_HAND_SIZE and draw_timer.is_stopped():
		draw_timer.start()
