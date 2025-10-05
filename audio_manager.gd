extends Node

const SOUNDS = {
	"tower_destroyed": preload("res://assets/sounds/tower_destroyed.wav"),
	"building_destroyed": preload("res://assets/sounds/building_destroyed.wav"),
	"unit_killed": preload("res://assets/sounds/unit_killed.wav"),
	"damage_taken": preload("res://assets/sounds/hit_sound.wav")
}

var audio_players: Array[AudioStreamPlayer] = []
var sound_level: float = 100.0
const POOL_SIZE = 16

func _ready() -> void:
	for i in POOL_SIZE:
		var player = AudioStreamPlayer.new()
		add_child(player)
		audio_players.append(player)

	EventBus.unit_died.connect(func(): play_sound("unit_killed"))
	EventBus.building_destroyed.connect(func(): play_sound("building_destroyed"))
	EventBus.tower_destroyed.connect(func(): play_sound("tower_destroyed"))
	#EventBus.damage_taken.connect(func(): play_sound("damage_taken"))
	
func set_master_volume() -> void:
	var normalized_volume = _get_normalized_volume(sound_level)
	for player in audio_players:
		player.volume_db = normalized_volume

func _get_normalized_volume(slider_value: float) -> float:
	var normalized = slider_value / 100.0
	var curved_volume = pow(normalized, 2)
	var volume_db = linear_to_db(curved_volume)
	return min(volume_db, 0.0)
	
func play_random(sounds: Array, volume_adjustment: float = 0.0) -> void:
	var player = _get_available_player()
	if player:
		player.stream = sounds.pick_random()
		player.volume_db = _get_normalized_volume(sound_level + volume_adjustment)
		player.play()

func play_sound(sound_name: String, volume_adjustment: float = 0.0) -> void:
	var player = _get_available_player()
	if player:
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		player.stream = SOUNDS[sound_name]
		player.volume_db = _get_normalized_volume(sound_level + volume_adjustment)
		player.play()

func _get_available_player() -> AudioStreamPlayer:
	for player in audio_players:
		if not player.playing:
			return player
	return null
	
