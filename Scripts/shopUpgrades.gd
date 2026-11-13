extends Panel

@onready var ability_menu1 = $abilityUpgrade1
@onready var ability_menu2 = $abilityUpgrade2
@onready var ability_menu3 = $abilityUpgrade3
@onready var levelCounter = $levelCounter
var character_abilities = preload("res://Scripts/Dungeon/card_control.gd").new()
 
var hero1Character = GameState.selected_party[0]
var hero2Character = GameState.selected_party[1]
var hero3Character = GameState.selected_party[2]
var rerollTokens = 1
func get_character_abilities(hero1Character):
	var available_abilities = []
	for ability in character_abilities.card_def:
		if character_abilities.card_def[ability][4] == hero1Character or character_abilities.card_def[ability][4] == "none":
			available_abilities.append(ability)
			print(available_abilities[0])
func _ready():
	print(GameState)
	print(GameState.current_level)
	print(GameState.selected_party)
	

func _on_hero_1_pressed() -> void:
	get_character_abilities(hero1Character)
	if GameState.current_level == 5:
			ability_menu1.text = hero1Character + " ability"
			ability_menu2.text = hero1Character + " ability"
	if GameState.current_level == 10:
			ability_menu1.text = hero1Character + " ability"
			ability_menu2.text = hero1Character + " ability"
	if GameState.current_level == 15:
			ability_menu1.text = hero1Character + " ability"
			ability_menu2.text = hero1Character + " ability"
	#if level = blah pick 3 abilities from this list random number 1-40 etc.


func _on_hero_2_pressed() -> void:
	if GameState.current_level == 5:
			ability_menu1.text = hero2Character + " ability"
			ability_menu2.text = hero2Character + " ability"
	if GameState.current_level == 10:
			ability_menu1.text = hero2Character + " ability"
			ability_menu2.text = hero2Character + " ability"
	if GameState.current_level == 15:
			ability_menu1.text = hero2Character + " ability"
			ability_menu2.text = hero2Character + " ability"

func _on_hero_3_pressed() -> void:
		if GameState.current_level == 5:
			ability_menu1.text = hero3Character + " ability"
			ability_menu2.text = hero3Character + " ability"
		if GameState.current_level == 10:
			ability_menu1.text = hero3Character + " ability"
			ability_menu2.text = hero3Character + " ability"
		if GameState.current_level == 15:
			ability_menu1.text = hero3Character + " ability"
			ability_menu2.text = hero3Character + " ability"

func _on_reroll_pressed() -> void:
	#for loop to identify character again
	#if level = blah: ability_menu.text = pick from this characterArray[i].txt file
	# reroll tokens = 0
	
	pass
