extends Panel

var CARD = preload("res://Scripts/card_init.gd").new()

@export var card_name: Array = ["basic_attack", "heavy_attack", "basic_heal"]
var card_desc: Array = ["", "", ""]

var current_card_1: Array = []
var current_card_2: Array = []
var current_card_3: Array = []

func _ready() -> void:
	#handle card 1
	current_card_1 = CARD.init(card_name[0])
	if (current_card_1 != []):
		$CardSlot1.text = card_name[0]
		card_desc[0] = current_card_1[2]
	
	#handle card 2
	current_card_2 = CARD.init(card_name[1])
	if (current_card_2 != []):
		$CardSlot2.text = card_name[1]
		card_desc[1] = current_card_2[2]
	
	#handle card 3
	current_card_3 = CARD.init("basic_heal")
	if (current_card_3 != []):
		$CardSlot3.text = card_name[2]
		card_desc[2] = current_card_3[2]
	
func use_card(owner, target, index):
	print(card_desc[index])
	match card_name[index]:
		"basic_attack":
			target.health -= 4
		"heavy_attack":
			target.health -= 8
		"basic_heal":
			owner.health += 4
