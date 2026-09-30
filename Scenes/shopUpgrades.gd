extends Panel

@onready var ability_menu1 = $abilityUpgrade1
@onready var ability_menu2 = $abilityUpgrade2
@onready var ability_menu3 = $abilityUpgrade3

func _on_hero_1_pressed() -> void:
	ability_menu1.text = ""
	ability_menu2.text = ""
	ability_menu3.text = ""

	#if level = blah pick 3 abilities from this list random number 1-40 etc.


func _on_hero_2_pressed() -> void:
	ability_menu1.text = ""
	ability_menu2.text = ""
	ability_menu3.text = ""
	

func _on_hero_3_pressed() -> void:
	ability_menu1.text = ""
	ability_menu2.text = ""
	ability_menu3.text = ""
	
