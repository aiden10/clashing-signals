extends Node

const HIT_PARTICLE_SCENE: PackedScene = preload("res://effects/HitParticle.tscn")
const RING_TEXTURE: Texture = preload("res://assets/ring.png")

func spawn_hit_particle(destination: Vector2) -> void:
	var hit_particle: CPUParticles2D = HIT_PARTICLE_SCENE.instantiate()
	hit_particle.global_position = destination
	hit_particle.emitting = true
	get_tree().current_scene.add_child(hit_particle)

func add_ring(target: Node) -> void:
	var ring_sprite: Sprite2D = Sprite2D.new()
	ring_sprite.texture = RING_TEXTURE
	ring_sprite.name = "RingSprite"
	target.add_child(ring_sprite)

func remove_ring(target: Node) -> void:
	var ring = target.get_node_or_null("RingSprite")
	if ring:
		ring.queue_free()
