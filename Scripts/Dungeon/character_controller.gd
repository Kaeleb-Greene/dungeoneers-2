extends CharacterBody2D

const IDLE_POSITION_PARTY = [Vector2(-448, -64), 
						Vector2(-320, 0), 
						Vector2(-448, 64),
						Vector2(-496, -64), 
						Vector2(-368, 0), 
						Vector2(-496, 64)]
const IDLE_POSITION_ENEMY = [Vector2(448, -64), 
						Vector2(320, 0), 
						Vector2(448, 64),
						Vector2(496, -64), 
						Vector2(368, 0), 
						Vector2(496, 64)]

# basic Stats [health, attack, defense]
var stats: Array[int] = [0, 0, 0]

var type: String = ""
var slot: int = 0

var attribute: String = ""
var cards: Dictionary = {
	"card_1": null,
	"card_2": null,
	"card_3": null
}

var is_boss: bool = false
var is_dead: bool = false
signal died(character: Node)

func _ready() -> void:
	update_position()
	#debug_messages()
	$Label.text = type

func update_position() -> void:
	if (self.is_in_group("Party")):
		position = IDLE_POSITION_PARTY[slot-1]
	elif (self.is_in_group("Enemy")):
		position = IDLE_POSITION_ENEMY[slot-1]

func get_available_cards() -> int:
	var card_counter: int = 0
	
	for card_key in cards:
		if (cards[card_key] != null):
			card_counter += 1;
	return card_counter

func debug_messages() -> void:
	print("Class: "+str(type))
	print("Health: "+str(stats[0]))
	print("Attack: "+str(stats[1]))
	print("Defense: "+str(stats[2]))
	print("Slot: "+str(slot)+"\n")

func _process(_float) -> void:
	if (stats[0] <= 0) && (!is_dead):
		is_dead = true
		died.emit(self)
		queue_free()
