extends Panel

@onready var ability_menu1 = $abilityUpgrade1
@onready var ability_menu2 = $abilityUpgrade2
@onready var ability_menu3 = $abilityUpgrade3
var hero1Character = "Knight"
var hero2Character = "Wizard"
var hero3Character = "Cleric"
var rerollTokens = 1

var characterArray = ["Wizard", "Rogue", "Alchemist", "Knight", "Cleric", ]

func _on_hero_1_pressed() -> void:
	for i in 5:
		if characterArray[i] == hero1Character:
			ability_menu1.text = ""
			ability_menu2.text = str(characterArray[i]) + " hero ability"

	#if level = blah pick 3 abilities from this list random number 1-40 etc.


func _on_hero_2_pressed() -> void:
	for i in 5:
		if characterArray[i] == hero2Character:
			ability_menu1.text = str(characterArray[i]) + " hero ability"
			ability_menu2.text = str(characterArray[i]) + " hero ability"	

func _on_hero_3_pressed() -> void:
	for i in 5:
		if characterArray[i] == hero3Character:
			#if levele = 5: ability_menu.text = Pick from .txt file 
			ability_menu1.text = str(characterArray[i]) + " hero ability"
			ability_menu2.text = str(characterArray[i]) + " hero ability"


func _on_reroll_pressed() -> void:
	#for loop to identify character again
	#if level = blah: ability_menu.text = pick from this characterArray[i].txt file
	# reroll tokens = 0
	
	pass
