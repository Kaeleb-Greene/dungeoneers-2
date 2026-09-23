extends Control

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/hub.tscn")

func _on_options_menu_pressed() -> void:
	print("temp-message.OptionsMenu")

func _on_quit_game_pressed() -> void:
	get_tree().quit()
