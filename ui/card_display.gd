extends PanelContainer

class_name CardDisplay

@onready var highlighted_panel: StyleBoxFlat = preload("res://ui/Highlight.tres")
@onready var unhighlighted_panel: StyleBoxFlat = preload("res://ui/Unhighlight.tres")
@onready var name_label: Label = $MarginContainer/VBoxContainer/CardName

func setup(card_name: String, image: Texture, cost: int) -> void:
	$MarginContainer/VBoxContainer/CardName.text = card_name
	$MarginContainer/VBoxContainer/Image.texture = image
	$MarginContainer/VBoxContainer/CenterContainer/ElixirCost.text = str(cost)

func is_empty() -> bool:
	return $MarginContainer/VBoxContainer/CardName.text == "MISSING"

func highlight() -> void:
	self.add_theme_stylebox_override("panel", highlighted_panel)

func unhighlight() -> void:
	self.add_theme_stylebox_override("panel", unhighlighted_panel)
