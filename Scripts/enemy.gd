extends CharacterBody2D

# set the starting positions 
# Vector2((grid position x+offset)*upscale), (grid position y+offset)*upscale)

const IDLE_POSITION = [Vector2(448, -64), 
					   Vector2(320, 0), 
					   Vector2(448, 64)]

# basic stats
var health: int = 0;
var attack: int = 0;
var defense: int = 0;

var attribute: String = "none"
var type: String = ""

var slot: int = 0
var active: bool = false;

func _ready() -> void:
	update_position()
	#debug_messages()
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

func _process(_float) -> void:
	if (health <= 0):
		queue_free()
		get_parent().turn_queue.erase(get_instance_id())
