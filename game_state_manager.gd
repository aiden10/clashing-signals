extends Node

@export var title_scene: PackedScene
@export var deck_scene: PackedScene
@export var game_scene: PackedScene

var current_scene: Node

func goto_scene(scene: PackedScene) -> void:
	if current_scene:
		current_scene.queue_free()

	current_scene = scene.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
