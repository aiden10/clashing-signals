extends Resource
class_name Card

@export var name: String
@export var cost: int
@export var count: int = 1
@export var image: Texture
@export var type: Constants.CARD_TYPES
@export var unit_scene: PackedScene
