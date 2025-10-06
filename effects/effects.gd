extends Node

const HIT_PARTICLE_SCENE: PackedScene = preload("res://effects/HitParticle.tscn")
const RING_TEXTURE: Texture = preload("res://assets/ring.png")
const HEART_TEXTURE: Texture = preload("res://assets/heart.png")
const WARNING_TEXTURE: Texture = preload("res://assets/warning.png")
const HELIX_TEXTURE: Texture = preload("res://assets/helix.png")
const SIGNAL_TEXTURE: Texture = preload("res://assets/signal.png")
const WRENCH_TEXTURE: Texture = preload("res://assets/wrench.png")

enum IMAGES {RING, HEART, WARNING, HELIX, SIGNAL, WRENCH}

const image_map: Dictionary[IMAGES, Texture] = {
	IMAGES.RING: RING_TEXTURE,
	IMAGES.HEART: HEART_TEXTURE,
	IMAGES.WARNING: WARNING_TEXTURE,
	IMAGES.HELIX: HELIX_TEXTURE,
	IMAGES.SIGNAL: SIGNAL_TEXTURE,
	IMAGES.WRENCH: WRENCH_TEXTURE
}

func spawn_hit_particle(destination: Vector2) -> void:
	var hit_particle: CPUParticles2D = HIT_PARTICLE_SCENE.instantiate()
	hit_particle.global_position = destination
	hit_particle.emitting = true
	get_tree().current_scene.add_child(hit_particle)

func add_image(target: Node, source: String, image: IMAGES, color: Color=Color(1.0, 1.0, 1.0, 1.0)) -> void:
	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = image_map[image]
	sprite.name = source
	sprite.modulate = color
	target.add_child.call_deferred(sprite)

func remove_image(target: Node, source: String) -> void:
	var sprite = target.find_child(source, false, false)
	if sprite:
		sprite.queue_free()
