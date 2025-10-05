extends PanelContainer

class_name CardDisplay

@onready var highlighted_panel: StyleBoxFlat = preload("res://ui/Highlight.tres")
@onready var unhighlighted_panel: StyleBoxFlat = preload("res://ui/Unhighlight.tres")
@onready var name_label: Label = $MarginContainer/VBoxContainer/CardName

func _ready() -> void:
	valid_selection()

func setup(card_name: String, image: Texture, cost) -> void:
	$MarginContainer/VBoxContainer/CardName.text = card_name
	$MarginContainer/VBoxContainer/Image.texture = image
	$MarginContainer/VBoxContainer/CenterContainer/ElixirCost.text = str(cost)
	valid_selection()

func is_empty() -> bool:
	return $MarginContainer/VBoxContainer/CardName.text == "MISSING" or $MarginContainer/VBoxContainer/CardName.text == ""

func highlight() -> void:
	self.add_theme_stylebox_override("panel", highlighted_panel)

func unhighlight() -> void:
	self.add_theme_stylebox_override("panel", unhighlighted_panel)

func selective_modulate(mod: Color) -> void:
	self.self_modulate = mod
	$MarginContainer.self_modulate = mod
	$MarginContainer/VBoxContainer/CardName.modulate = mod

func valid_selection() -> void:
	if is_empty():
		self.selective_modulate(Color(18.892, 18.892, 0.0))
	else:
		self.selective_modulate(Color(1, 1, 1, 1))

func invalid_selection() -> void:
	self.selective_modulate(Color(18.892, 0.0, 0.0))
