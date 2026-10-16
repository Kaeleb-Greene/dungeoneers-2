extends Panel

#Card type + Description
var card_def: Dictionary = {
	#Player
	"basic_attack": ["attack", 4, "Attacks the enemy for 4 damage"],
	"heavy_attack": ["attack", 8, "Attacks the enemy for 8 damage"],
	"basic_heal": ["heal", 4, "Heals the target 4 health"],
	#Monster
	"bite": ["attack", 2, "Bites a party member inflicting 2 damage"],
	"shoot_arrow": ["attack", 3, "Shoot an arror at a party member inflicting 2 damage"], 
	"rally": ["buff", 2, "Organizes other monsters raising their attack by 2"]
	}

var card_order: Dictionary = {
	"current_card_1": "basic_attack",
	"current_card_2": "heavy_attack",
	"current_card_3": "basic_heal"
}

@onready var card_slots: Array = [
	$CardSlot1,
	$CardSlot2,
	$CardSlot3
]

func _ready() -> void:
	update_card_slots()
	
func update_card_slots():
	for i in range(card_slots.size()):
		var order_key: String = "current_card_" + str(i+1)
		var card_key: String = card_order.get(order_key, "")
	
		if card_def.has(card_key):
			card_slots[i].text = str(card_key)
		else:
			card_slots[i].text = "No card assigned"

#Returns the entire definition for a card
func get_card_data(card_key) -> Array:
	if (!card_def.has(card_key)):
		push_warning("Card not found: "+str(card_key))
		return []

	return card_def[card_key]

#Returns an individual card's type
func get_card_type(card_key) -> String:
	var data: Array = get_card_data(card_key)
	if (data.is_empty()):
		return ""
	
	return String(data[0])
	
#Returns an individual card's type
func get_card_value(card_key) -> int:
	var data: Array = get_card_data(card_key)
	if (data.is_empty()):
		return 0
	
	return int(data[1])
	
#Returns an individual card's type
func get_card_desc(card_key) -> String:
	var data: Array = get_card_data(card_key)
	if (data.is_empty()):
		return ""
	
	return String(data[2])

func use_card(card_key, target):
	var card_type: String = get_card_type(card_key)
	var effect_value: int = get_card_value(card_key)
	
	
	match card_type:
		"attack":
			match card_key:
				"basic_attack":
					target.health -= effect_value
				"heavy_attack":
					target.health -= effect_value
				"bite":
					target.health -= effect_value
				"shoot_arrow":
					target.health -= effect_value
		"heal":
			match card_key:
				"basic_heal":
					target.health += effect_value
				"mega_heal":
					target.health += effect_value
		"buff":
			match card_key:
				"rally":
					pass
		"debuff":
			pass
