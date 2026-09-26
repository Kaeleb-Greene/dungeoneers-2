extends CharacterBody2D

var health = 0;
var attack = 0;
var defense = 0;
var speed = 0;

var attribute = "none"
var type = ""

var slot = 0

func _ready() -> void:
	update_position()
	debug_messages()
	
func update_position() -> void:
	match slot:
		1:
			global_position = Vector2(900, 150)
		2:
			global_position = Vector2(1000, 300)
		3:
			global_position = Vector2(900, 450)

func debug_messages() -> void:
	print("Type: "+str(type))
	print("Health: "+str(health))
	print("Attack: "+str(attack))
	print("Defense: "+str(defense))
	print("Speed: "+str(speed))
	print("Attribute: "+str(attribute))
	print("Slot: "+str(slot)+"\n")
