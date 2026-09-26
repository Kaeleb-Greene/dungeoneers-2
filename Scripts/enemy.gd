extends CharacterBody2D

var health = 0;
var attack = 0;
var defense = 0;

var attribute = "none"

var slot = 0

func _ready() -> void:
	update_position()
	
func update_position() -> void:
	match slot:
		1:
			global_position = Vector2(900, 150)
		2:
			global_position = Vector2(1000, 300)
		3:
			global_position = Vector2(900, 450)
			
			
			
