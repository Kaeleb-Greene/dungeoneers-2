extends Control

const TRANSITIONS = preload("res://Scripts/Control/transition.gd")

var transitions = TRANSITIONS.new()

func _process(_delta) -> void:
	if (Input.is_action_just_pressed("Debug_Move_To_Next_Scene")):
		transitions.start_dungeon(get_tree())
