extends Control

const TRANSITIONS = preload("res://Scripts/Control/transition.gd")

var transitions := TRANSITIONS.new()

func _on_start_game_pressed() -> void:
	transitions.go_to_character_selection(get_tree())

func _on_options_menu_pressed() -> void:
	print("temp-message.OptionsMenu")

func _on_quit_game_pressed() -> void:
	get_tree().quit()
