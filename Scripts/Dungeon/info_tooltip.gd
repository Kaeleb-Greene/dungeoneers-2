extends CanvasLayer

@onready var panel: PanelContainer = $PanelContainer
@onready var title_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Title
@onready var description_label: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/Description

var tooltip_visible: bool = false

func _ready() -> void:
	hide_info()
	
func show_info(data: Dictionary) -> void:
	title_label.text = str(data.get("title", "Unknown"))
	
	var lines: Array = data.get("lines", [])
	description_label.text = "\n".join(lines)
	
	if (panel != null):
		panel.show()
		tooltip_visible = true
	
func hide_info() -> void:
	if (panel != null):
		panel.hide()
		tooltip_visible = false

func _process(_delta: float) -> void:
	if !tooltip_visible:
		return
	
	#Follow the mouse cursor
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	
	var tooltip_position: Vector2 = mouse_position + Vector2(18, 18)
	
	#Keep the tooltip inside the screen
	tooltip_position.x = clampf(tooltip_position.x, 0.0, maxf(0.0, viewport_size.x - panel.size.x))
	
	tooltip_position.y = clampf(tooltip_position.y, 0.0, maxf(0.0, viewport_size.y - panel.size.y))
	
	panel.position = tooltip_position
