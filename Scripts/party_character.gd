extends CharacterBody2D

const IDLE_POSITION = [Vector2(-448, -64), 
					   Vector2(-320, 0), 
					   Vector2(-448, 64)]

# basic Stats
var health: int = 0;
var attack: int = 0;
var defense: int = 0;

var character_class: String = "";
var slot: int = 0;

func _ready() -> void:
	update_position()
	#debug_messages()
	$Label.text = character_class

func update_position() -> void:
	position = IDLE_POSITION[slot-1]
	
func debug_messages() -> void:
	print("Class: "+str(character_class))
	print("Health: "+str(health))
	print("Attack: "+str(attack))
	print("Defense: "+str(defense))
	print("Slot: "+str(slot)+"\n")

func _process(_float) -> void:
	if (health <= 0):
		queue_free()
		get_parent().turn_queue.erase(get_instance_id())
