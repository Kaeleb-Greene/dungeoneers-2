extends Node


func display_value(value: int, _position: Vector2, critical_value: bool = false) -> void:
	var number = Label.new()
	number.global_position = _position
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()

	var color = "#FFBF00"
	if (critical_value):
		color = "#B22"
	if (value == 0):
		color = "#FFF8"
	
	number.label_settings.font = load("res://Assets/Fonts/PixeloidMono.ttf")
	number.label_settings.font_color = color
	number.label_settings.font_size = 32
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 5
	
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.25
	).set_ease(Tween.EASE_IN)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_OUT).set_delay(0.25)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_OUT).set_delay(0.5)
	
	await tween.finished
	number.queue_free()
