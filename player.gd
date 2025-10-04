extends Node

class_name Player

var player: Constants.PLAYERS
var hand: Hand
var deck: Deck
var cursor: Node2D
var elixir: int = 10
var can_place: bool = true
var action_timer: Timer

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
	add_child(action_timer)

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
		self.cursor.position += direction.normalized() * self.cursor.speed * delta

func use_selected_card():
	var card = self.hand.get_selected()
	if not card:
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
			unit.global_position = cursor.global_position + Vector2(randi_range(-50, 50), randi_range(-50, 50))
			unit.player = self.player
			get_tree().current_scene.add_child(unit)
	
	elif card.type == Constants.CARD_TYPES.SPELL:
		var spell = card.scene.instantiate()
		spell.global_position = cursor.global_position
		spell.player = self.player
		get_tree().current_scene.add_child(spell)

	var new_card = self.deck.draw_card()
	if new_card:
		self.hand.cards[self.hand.selected_index] = new_card
		EventBus.hand_updated.emit(self.player)
