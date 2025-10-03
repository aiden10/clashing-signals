extends Node

enum PLAYERS {P1, P2}

# used for deckbuilding ui
enum SelectionArea { SELECTION, DECK, READY }

const ELIXIR_COOLDOWN: float = 2.5
const CURSOR_SPEED: float = 500
const MAX_DECK_SIZE: int = 8
const MAX_HAND_SIZE: int = 4
const ACTION_COOLDOWN: float = 1.5

const KNIGHT_HEALTH: int = 10
const KNIGHT_DAMAGE: float = 2
const KNIGHT_SPEED: float = 25
const KNIGHT_MELEE: bool = true
const KNIGHT_COOLDOWN: float = 1.5

const TOWER_COOLDOWN: float = 2.0
const TOWER_HEALTH: int = 100
var TOWER_PROJECTILE: PackedScene = preload("res://projectiles/Arrow.tscn")

const ARROW_SPEED: float = 500
const ARROW_DAMAGE: float = 3
const ARROW_PIERCE_LIMIT: int = 2

const CARD_DISPLAY: PackedScene = preload("res://ui/CardDisplay.tscn")
const KNIGHT_CARD: Card = preload("res://cards/knight_card.tres")
