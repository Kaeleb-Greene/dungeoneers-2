extends CharacterBody2D

# set the starting positions 
# Vector2((grid position x+offset)*upscale), (grid position y+offset)*upscale)

const IDLE_POSITION = [Vector2(1280-320, 320), 
					   Vector2(1280-448, 384), 
					   Vector2(1280-320, 448)]

# basic stats
var health = 0;
var attack = 0;
var defense = 0;

var attribute = "none"
var type = ""

var slot = 0

func _ready() -> void:
	update_position()
	debug_messages()
	$Label.text = type
	
func update_position() -> void:
	#change the position of the enemy based on what slot they are in
	position = IDLE_POSITION[slot-1]

func debug_messages() -> void:
	print("Type: "+str(type))
	print("Health: "+str(health))
	print("Attack: "+str(attack))
	print("Defense: "+str(defense))
	print("Attribute: "+str(attribute))
	print("Position: "+str(position))
	print("Slot: "+str(slot)+"\n")
	
