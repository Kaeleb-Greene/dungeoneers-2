extends CanvasLayer

@onready var pause_menu = $pauseMenu
@onready var options_menu = $optionsMenu
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
		
		
func toggle_pause():
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
	options_menu.visible = false
		



func _on_resume_button_pressed() -> void:
	pause_menu.visible = false
	
func _on_exit_pressed() -> void:
	get_tree().quit()
	
func _on_options_pressed() -> void:
	options_menu.visible = true
	pause_menu.visible = false
	


func _on_resume_button_2_pressed() -> void:
	options_menu.visible = false
