extends Node

@export var title_scene: PackedScene
@export var deck_scene: PackedScene
@export var game_scene: PackedScene

@export var scenes: Dictionary[Constants.GAME_SCENES, PackedScene]
var current_scene: Node

func _ready() -> void:
	scenes[Constants.GAME_SCENES.TITLE] = title_scene
	scenes[Constants.GAME_SCENES.DECK] = deck_scene
	scenes[Constants.GAME_SCENES.GAME] = game_scene
	current_scene = get_tree().current_scene

func goto_scene(scene_type: Constants.GAME_SCENES) -> void:
	var scene = scenes[scene_type]
	print(scenes,scene_type, scenes[scene_type])
	if current_scene:
		current_scene.queue_free()

	current_scene = scene.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
