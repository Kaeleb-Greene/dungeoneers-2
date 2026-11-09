extends Panel

const TRANSITIONS = preload("res://Scripts/Control/transition.gd")

var transitions = TRANSITIONS.new()

@onready var ability_menu1 = $abilityUpgrade1
@onready var ability_menu2 = $abilityUpgrade2
@onready var ability_menu3 = $abilityUpgrade3
@onready var levelCounter = $levelCounter
var character_abilities = preload("res://Scripts/Dungeon/card_control.gd")
 
var hero1Character = GameState.selected_party[0]
var hero2Character = GameState.selected_party[1]
var hero3Character = GameState.selected_party[2]
var rerollTokens = 1
func get_abilities() -> Array:
	var foundCharacter = false
	var hero1Abilities = []
	for key in character_abilities.card_def.keys(hero1Character, ""):
		if key == "### " + hero1Character + " ###":
			foundCharacter == true
			continue 
		if foundCharacter:
			if key.begins_with("###"):
				break
		hero1Abilities.append(key)
		if hero1Abilities.size() == 3:
			break
	return []
func _ready():
	print(GameState)
	print(GameState.current_level)
	print(GameState.selected_party)

func _on_hero_1_pressed() -> void:
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

func _process(_delta) -> void:
	if (Input.is_action_just_pressed("Debug_Move_To_Next_Scene")):
		GameState.available_room_types.erase(GameState.current_room_type)
		var rooms: Array[String] = GameState.available_room_types
		
		GameState.current_room_type = rooms[randi_range(0, rooms.size())]
		transitions.start_dungeon(get_tree())
