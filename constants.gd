extends Node

enum PLAYERS {P1, P2}
enum CARD_TYPES {UNIT, SPELL, BUILDING}

# used for deckbuilding ui
enum SelectionArea { SELECTION, DECK, READY }

enum GAME_SCENES {TITLE, DECK, GAME}

## Cursors
const COLOR_P1 = Color("ff4000ff")
const COLOR_P2 = Color("DEEP_SKY_BLUE")
const INVALID_DARKENING = 0.50
const CURSOR_SPEED: float = 500

## MISCELLANEOUS
const ELIXIR_COOLDOWN: float = 2.8
const STAGE1_DURATION: float = 120
const ELIXIR_COOLDOWN2: float = 1.4
const STAGE2_DURATION: float = 120
const ELIXIR_COOLDOWN3: float = 0.9
const MIN_DISTANCE: float = 50.0  
const PUSH_STRENGTH: float = 500.0

const MAX_ELIXIR: int = 10
const MAX_DECK_SIZE: int = 8
const MAX_HAND_SIZE: int = 5
const DRAW_COOLDOWN: float = 2.0
const ACTION_COOLDOWN: float = 0.5

## Each signal in range boosts stats by this percent.
const SIGNAL_DAMAGE_BUFF: float = 0.50 ## (additive)
const SIGNAL_SPEED_BUFF: float = 0.50 ## (additive) 
const SIGNAL_COOLDOWN_BUFF: float = 0.15 ## (multiplicative)

const SEVER_DEBUFF: float = 2.0

## SPELLS
const SIGNAL_BOOST_DURATION: float = 5
const EMP_DURATION: float = 5

const FIREBALL_DAMAGE: float = 10
const FIREBALL_DURATION: float = 1
const FIREBALL_SPEED: float = 800

const HP_EQUALIZER_HEALTH: float = 5.0
const HP_EQUALIZER_DURATION: float = 0.5

const REPAIR_DURATION: float = 0.5

const CLONE_DEBUFF: float = 3
const CLONE_DURATION: float = 0.25

## UNITS
const KNIGHT_HEALTH: float = 15
const KNIGHT_DAMAGE: float = 3
const KNIGHT_SPEED: float = 25
const KNIGHT_MELEE: bool = true
const KNIGHT_COOLDOWN: float = 1.0

const PAWN_HEALTH: float = 7.5
const PAWN_DAMAGE: float = 1.5
const PAWN_SPEED: float = 30
const PAWN_MELEE: bool = true
const PAWN_COOLDOWN: float = 1.0

const DUMMY_HEALTH: float = 0.1
const DUMMY_DAMAGE: float = 0.5
const DUMMY_SPEED: float = 30
const DUMMY_MELEE: bool = true
const DUMMY_COOLDOWN: float = 1.0

const PERSON_HEALTH: float = 5.0
const PERSON_DAMAGE: float = 1.0
const PERSON_SPEED: float = 30
const PERSON_MELEE: bool = true
const PERSON_COOLDOWN: float = 1.0

const GIANT_HEALTH: float = 35
const GIANT_DAMAGE: float = 5
const GIANT_SPEED: float = 20
const GIANT_MELEE: bool = true
const GIANT_COOLDOWN: float = 2.0

const ARCHER_HEALTH: float = 5
const ARCHER_DAMAGE: float = 1.5
const ARCHER_SPEED: float = 35
const ARCHER_MELEE: bool = false
const ARCHER_COOLDOWN: float = 1.5
const ARCHER_PROJECTILE: PackedScene = preload("res://projectiles/Arrow.tscn")

const POCKET_WIFI_HEALTH: float = 5
const POCKET_WIFI_DAMAGE: float = 2.0
const POCKET_WIFI_SPEED: float = 40
const POCKET_WIFI_MELEE: bool = true
const POCKET_WIFI_COOLDOWN: float = 2.0

const DRONE_HEALTH: float = 1
const DRONE_DAMAGE: float = 1
const DRONE_SPEED: float = 65
const DRONE_MELEE: bool = true
const DRONE_COOLDOWN: float = 1.3

const CANNON_HEALTH: float = 10
const CANNON_DAMAGE: float = 5
const CANNON_SPEED: float = 15
const CANNON_MELEE: bool = false
const CANNON_COOLDOWN: float = 10
const CANNON_PROJECTILE: PackedScene = preload("res://projectiles/Boulder.tscn")

const JUGGERNAUT_HEALTH: float = 60
const JUGGERNAUT_DAMAGE: float = 8
const JUGGERNAUT_SPEED: float = 20
const JUGGERNAUT_MELEE: bool = true
const JUGGERNAUT_COOLDOWN: float = 1.5

const TOWER_COOLDOWN: float = 3.5
const TOWER_DAMAGE: float = 0.5
const TOWER_HEALTH: int = 50
var TOWER_PROJECTILE: PackedScene = preload("res://projectiles/Arrow.tscn")
const TOWER_SCENE: PackedScene = preload("res://Buildings/Tower.tscn")

# BUILDINGS
const FACTORY_HEALTH: float = 20
const FACTORY_COOLDOWN: float = 10
const FACTORY_SPAWN_SCENE: PackedScene = preload("res://units/Drone.tscn")
const FACTORY_SPAWN_COUNT: int = 3
const FACTORY_DECAY_DAMAGE: float = 4

const SIGNAL_TOWER_HEALTH: float = 20
const SIGNAL_TOWER_DECAY_DAMAGE: float = 2

const JAMMER_TOWER_HEALTH: float = 20
const JAMMER_TOWER_DECAY_DAMAGE: float = 2

const EXTRACTOR_HEALTH: float = 20
const EXTRACTOR_DECAY_DAMAGE: float = EXTRACTOR_HEALTH/12
const EXTRACTOR_COOLDOWN: float = 3

const WALL_HEALTH: float = 35
const WALL_DECAY_DAMAGE: float = WALL_HEALTH/15
const WALL_COOLDOWN: float = 1.0

const BACKDOOR_HEALTH: float = 20
const BACKDOOR_DECAY_DAMAGE: float = BACKDOOR_HEALTH/200
const BACKDOOR_COOLDOWN: float = 0.1
const BACKDOOR_SPAWN_SCENE: PackedScene = preload("res://Buildings/BackDoor.tscn")
const BACKDOOR_TARGET_ENEMY: bool = false

## PROJECTILES
const ARROW_SPEED: float = 1000
const ARROW_DAMAGE: float = 3
const ARROW_PIERCE_LIMIT: int = 1

const CANNONBALL_SPEED: float = 400
const CANNONBALL_DAMAGE: float = 5
const CANNONBALL_PIERCE_LIMIT: int = 3

## CARDS
const CARD_DISPLAY: PackedScene = preload("res://ui/CardDisplay.tscn")
const KNIGHT_CARD: Card = preload("res://cards/knight_card.tres")
const ARCHER_CARD: Card = preload("res://cards/archer_card.tres")
const GIANT_CARD: Card = preload("res://cards/giant_card.tres")
const SIGNAL_BOOST_CARD: Card = preload("res://cards/signal_boost_card.tres")
const FACTORY_CARD: Card = preload("res://cards/factory_card.tres")
const SIGNAL_TOWER_CARD: Card = preload("res://cards/signal_tower_card.tres")
const EMP_CARD:Card = preload("res://cards/emp_card.tres")
const CANNON_CARD: Card = preload("res://cards/cannon_card.tres")
const JUGGERNAUT_CARD: Card = preload("res://cards/juggernaut_card.tres")
const JAMMER_CARD: Card = preload("res://cards/jammer_card.tres")
const EXTRACTOR_CARD: Card = preload("res://cards/extractor_card.tres")
const BACKDOOR_CARD: Card = preload("res://cards/backdoor_card.tres")
const FIREBALL_CARD: Card = preload("res://cards/fireball_card.tres")
const DUMMY_CARD: Card = preload("res://cards/dummy_card.tres")
const PEOPLE_CARD: Card = preload("res://cards/people_card.tres")
const HP_EQUALIZER_CARD: Card = preload("res://cards/hp_equalizer_card.tres")
const CLONE_CARD: Card = preload("res://cards/clone_card.tres")
const PAWN_CARD: Card = preload("res://cards/pawn_card.tres")
const WALL_CARD: Card = preload("res://cards/wall_card.tres")
const POCKET_WIFI_CARD: Card = preload("res://cards/pocket_wifi_card.tres")
const REPAIR_CARD: Card = preload("res://cards/repair_card.tres")

const CARDS: Array[Card] = [KNIGHT_CARD, ARCHER_CARD, GIANT_CARD, 
							SIGNAL_BOOST_CARD, FACTORY_CARD, EMP_CARD, BACKDOOR_CARD,
							SIGNAL_TOWER_CARD, CANNON_CARD, JUGGERNAUT_CARD, JAMMER_CARD,
							EXTRACTOR_CARD, FIREBALL_CARD, DUMMY_CARD, PEOPLE_CARD,
							HP_EQUALIZER_CARD, CLONE_CARD, PAWN_CARD, WALL_CARD,
							POCKET_WIFI_CARD, REPAIR_CARD]
