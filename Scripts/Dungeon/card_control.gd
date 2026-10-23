extends Panel

#Card type + Description
var card_def: Dictionary = {
	
	#region PLAYER
	
	### UNIVERSAL ###
	
	"basic_attack": ["attack", 3, "Attacks the enemy for 3 damage"],
	"heavy_attack": ["attack", 6, "Attacks the enemy for 6 damage"],
	"basic_heal": ["heal", 4, "Heals the target 4 health"],
	
	#region TANK
	
	### BASIC ###
	"taunt": ["debuff", 0, "Forces all monsters to attack this character until their next turn."],
	
	### KNIGHT ###
		#SPECIAL
		
		#ADVANCED
	
	### DWARF ###
		#SPECIAL
		
		#ADVANCED
		
	### BARBARIAN ###
		#SPECIAL
		
		#ADVANCED
		
	### NECROMANCER ###
		#SPECIAL
		
		#ADVANCED
	
	#endregion
	
	#region DAMAGE
	
	### BASIC ###
	
	### WIZARD ###
		#SPECIAL
		
		#ADVANCED
	
	### ARCHER ###
		#SPECIAL
		
		#ADVANCED
		
	### HUNTSMAN ###
		#SPECIAL
		
		#ADVANCED
		
	### LANDON ###
		#SPECIAL
		
		#ADVANCED
	
	#endregion
	
	#region SUPPORT
	
	### BASIC ###
	
	### ROGUE ###
		#SPECIAL
		
		#ADVANCED
	
	### CLERIC ###
		#SPECIAL
		
		#ADVANCED
		
	### ALCHEMIST ###
		#SPECIAL
		
		#ADVANCED
		
	### DRUID ###
		#SPECIAL
		
		#ADVANCED
	
	#endregion
	
	#endregion
	
	#region MONSTER
	
	#region CRYPT
	
	### ZOMBIE ###
	"bite": ["attack", 2, "Bites a party member inflicting 2 damage"],
	"scratch": ["attack", 2, "Bites a party member inflicting 2 damage"],
	
	### SKELETON ###
	"shoot_arrow": ["attack", 3, "Shoot an arrow at a party member inflicting 2 damage"],
	
	### RAIDER ###
	"shoot_bolt": ["attack", 4, "Shoot a bolt at a party member inflicting 4 damage"],
	"raider_axe_throw": ["attack", 4, "Throw an axe at a party member inflicting 4 damage"],
	"rally": ["buff", 2, "Organizes other monsters raising their attack by 2"],
	
	### MEGA KNIGHT ###
	"mega_strike": ["attack", 6, "Strikes a party member inflicting 6 damage"],
	"mega_heal": ["heal", 7, "Shoot a bolt at a party member inflicting 4 damage"],
	
	#endregion
	
	#region SWAMP
	
	### GOBLIN ###
	"dagger_throw": ["attack", 4, "Strikes a party member inflicting 4 damage"],
	"poison_strike": ["attack", 3, "Strikes a party member inflicting 3 damage and 2 poison"]
	
	### ORC ###
	
	### TROLL ###
	
	### OGRE ###
	
	#endregion
	
	#region CURSED_TOMB
	
	### PHARAOH ###
	
	### MUMMY ###
	
	### SCARAB BEETLE ###
	
	### COBRA ###
	
	### ANUBIS ACOLYTE ###
	
	#endregion 
	
	#region ENCHANTED_LIBRARY
		
	### DARK WIZARD ### 
	
	### CURSED BOOK ###
	
	### EVIL LIBRARIAN ###
	
	### CULTIST ###
	
	### GOLEM ###
		
	#endregion
	
	#region HELLSCAPE
	
	### FLYING DEMON ###
	
	### FIRE IMP ###
	
	### LAVA FROG ###
	
	### FIRE SERPENT ###
	
	#endregion
	
	#region FROZEN CAVERN
	
	### FROST TROLLS ###
	
	### MAMMOTH ###
	
	### SABERTOOTH TIGER ###
	
	### YETI ###
	
	#endregion
	
	#region DRAGON DEN
	
	### DRAKE ###
	
	### KOBALD ###
	
	### DRAGON ###
	
	#endregion
	
	#endregion
	
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
			target.health -= effect_value*10
		"heal":
			target.health += effect_value
		"buff":
			match card_key:
				"rally":
					pass
		"debuff":
			pass
