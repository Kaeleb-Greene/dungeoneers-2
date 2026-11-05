extends CharacterBody2D

@onready var healthbar = $Healthbar

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
var stats: Array[float] = [0.0, 0.0, 0.0]
var max_health: float = 0.0

var modifiers: Array[Dictionary] = []

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
signal character_clicked(character: Node)

func _ready() -> void:
	#Allow this character to be clicked on
	input_pickable = true
	input_event.connect(_on_input_event)
	
	healthbar.init_health(stats[0])
	update_position()
	#debug_messages()
	$Label.text = type

func _on_input_event(_viewport: Viewport, event: InputEvent, _shape_index: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			character_clicked.emit(self)

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

#Add a modifier
func add_modifier(id: StringName, trigger: StringName, value: float = 0.0, remaining_uses: int = -1) -> void:
	var new_modifier: Dictionary = {
		"id": id,
		"trigger": trigger,
		"value": value,
		"remaining_uses": remaining_uses
	}
	
	modifiers.append(new_modifier)
	print(modifiers)
	print_rich("[color=orange]Added Modifier: ", id, " to ", type)

#Remove or decrease a modifier after activation
func consume_modifier(index: int) -> void:
	
	if index < 0 or index >= modifiers.size():
		return
		
	var remaining: int = int(
		modifiers[index].get("remaining_uses", -1)
	)
	
	#-1 means unlimited uses
	if remaining < 0:
		return
	
	remaining -= 1
	
	if remaining <= 0:
		modifiers.remove_at(index)
	else:
		modifiers[index]["remaining_uses"] = remaining
	
func _process(_float) -> void:
	if (stats[0] <= 0) && (!is_dead):
		is_dead = true
		died.emit(self)
		queue_free()
