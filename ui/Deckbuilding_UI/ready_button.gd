extends Panel

# contains highlight and unhighlight to keep consistent with other ui elements
@onready var highlighted_panel: StyleBoxFlat = preload("res://ui/Highlight.tres")
@onready var unhighlighted_panel: StyleBoxFlat = preload("res://ui/Unhighlight.tres")

signal switched_element
signal ready_pressed

func handle_input(input: Dictionary) -> void:
	if input["down"]:
		unhighlight()
		switched_element.emit(Vector2.DOWN, self.Position)
	elif input["left"]:
		unhighlight()
		switched_element.emit(Vector2.LEFT, self.Position)
	elif input["use"]:
		ready_pressed.emit()

func highlight() -> void:
	self.add_theme_stylebox_override("panel", highlighted_panel)

func unhighlight() -> void:
	self.add_theme_stylebox_override("panel", unhighlighted_panel)
