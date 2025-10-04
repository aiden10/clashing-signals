extends Node

@export var title_scene: PackedScene
@export var deck_scene: PackedScene
@export var game_scene: PackedScene

@export var scenes: Dictionary[String, PackedScene]
var current_scene: Node

func _ready() -> void:
	scenes["title scene"] = title_scene
	scenes["deck scene"] = deck_scene
	scenes["game scene"] = game_scene
	current_scene = get_tree().current_scene

func goto_scene(scene_name: String) -> void:
	var scene = scenes[scene_name]
	print(scenes,scene_name, scenes[scene_name])
	if current_scene:
		current_scene.queue_free()

	current_scene = scene.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
