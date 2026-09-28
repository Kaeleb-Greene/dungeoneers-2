extends CharacterBody2D

const IDLE_POSITION = [Vector2(320, 320), 
					   Vector2(448, 384), 
					   Vector2(320, 448)]

# basic Stats
var health = 0;
var attack = 0;
var defense = 0;

var character_class = "";
var slot = 0;

func _ready() -> void:
	debug_messages()
	update_position()
	$Label.text = character_class
	
func update_position() -> void:
	position = IDLE_POSITION[slot-1]
	
func debug_messages() -> void:
	print("Class: "+str(character_class))
	print("Health: "+str(health))
	print("Attack: "+str(attack))
	print("Defense: "+str(defense))
	print("Slot: "+str(slot)+"\n")
