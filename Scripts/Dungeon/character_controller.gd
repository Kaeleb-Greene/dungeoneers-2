extends CharacterBody2D

@onready var healthbar = $Healthbar
@onready var damage_numbers = $DamageNumbersOrigin

const IDLE_POSITION_PARTY = [Vector2(-448, -64), 
						Vector2(-320, 0), 
						Vector2(-448, 64),
						Vector2(-320, -64),
						Vector2(-240, 0), 
						Vector2(-320, 64)]
const IDLE_POSITION_ENEMY = [Vector2(448, -64), 
						Vector2(320, 0), 
						Vector2(448, 64),
						Vector2(576, -64), 
						Vector2(496, 0), 
						Vector2(576, 64)]

# basic Stats [health, attack, defense]
var stats: Array[float] = [0.0, 0.0, 0.0]
var max_health: float = 0.0

var modifiers: Array[Dictionary] = []
var skip_turn = false #for freeze and petrified modifiers

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
var is_summon: bool = false

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
func add_modifier(id: StringName, trigger: StringName, value: float = 0.0, remaining_uses: int = 1, duration: int = 0, source: Node = null, additional_conditions: Dictionary = {}) -> void:
	var new_modifier: Dictionary = {
		"id": id,
		"trigger": trigger,
		"value": value,
		"remaining_uses": remaining_uses,
		"duration": duration,
		"source": source,
		"additional_conditions": additional_conditions
	}
	
	modifiers.append(new_modifier)
	print_rich("[color=orange]Added Modifier: ", id, " to ", type)

#Remove or decrease a modifier after activation
func consume_modifier(index: int) -> void:
	var id = modifiers[index].get("id")
	if index < 0 or index >= modifiers.size():
		return
		
	var remaining: int = int(
		modifiers[index].get("remaining_uses", -1)
	)
	
	if remaining < 0:
		return
	
	remaining -= 1
	
	if remaining <= 0:
		if (id == "drunken_rage"):
			add_modifier(&"petrify_next", &"start_of_turn", 1.0, 1, 1, self)
		modifiers.remove_at(index)
	else:
		modifiers[index]["remaining_uses"] = remaining

func remove_modifier(id: StringName) -> void:
	for i in range(modifiers.size() -1, -1, -1):
		if (modifiers[i].get("id") == id):
			modifiers.remove_at(i)

func process_modifier_duration() -> void:
	for i in range(modifiers.size() -1, -1, -1):
		var duration: int = int(modifiers[i].get("duration", 0))
		
		if duration < 0:
			continue
			
		if duration > 0:
			duration -= 1
			
			if duration <= 0:
				modifiers.remove_at(i)
			else:
				modifiers[i]["duration"] = duration

func apply_damage_numbers(damage: float, critical_value: bool = false) -> void:
	DamageNumbers.display_value(damage, damage_numbers.global_position, critical_value)

func get_inspection_data() -> Dictionary:
	var lines: Array[String] = []
	
	lines.append("Health: %s / %s" % [stats[0], max_health])
	
	lines.append("Attack: %s" % stats[1])
	lines.append("Defense: %s" % stats[2])
	
	if (is_in_group("Party")):
		lines.append("Group: Party")
	else:
		lines.append("Group: Enemy")
	
	lines.append("")
	lines.append("Active Modifiers:")
	
	if (modifiers.is_empty()):
		lines.append("None")
	else:
		for modifier in modifiers:
			var modifier_name: String = str(modifier.get("id", "Unknown"))
			var uses: int = int(modifier.get("remaining_uses", -1))
			var duration: int = int(modifier.get("duration", 0))
			
			var modifier_text: String = modifier_name
			
			if uses == -1:
				modifier_text += " (Unlimited)"
			else:
				modifier_text += " (%s uses)" % uses
			
			if duration > 0:
				modifier_text += " (%s turns)" % duration
			elif duration == -1:
				modifier_text += "(Permanent)"
			
			lines.append(modifier_text)
	
	return {
		"title": name,
		"lines": lines
	}

func heal(amount: float) -> float:
	var owner: Node = self
	
	for curse in modifiers:
		
		if (curse.get("id") == &"underworld_curse"):
			var source = curse.get("source", null)
			
			if (!is_instance_valid(source)) || source.is_dead:
				push_error("Underworld Curse has an invalid source!")
				continue
			
			owner = source
			break
		
	if owner.is_dead:
		return 0
	
	var old_health: float = owner.stats[0]
	owner.stats[0] = snapped(minf(owner.max_health, owner.stats[0] + amount), 0.1)
	
	var actual_health: float = snapped((owner.stats[0] - old_health), 0.1)
	owner.healthbar.set_health(owner.stats[0])
	
	return actual_health

func check_death() -> void:
	if (stats[0] <= 0) && (!is_dead):
		is_dead = true
		died.emit(self)
		queue_free()
