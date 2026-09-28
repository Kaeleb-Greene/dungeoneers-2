extends Node2D

const ENEMY_SCENE = preload("res://Scenes/enemy.tscn")
const CHARACTER_SCENE = preload("res://Scenes/party_character.tscn")

@export var current_level = randi_range(1, 20)

# slots that will hold information for each enemy and character instance
var slots = {"slot_1": null,
			 "slot_2": null,
			 "slot_3": null,
			 "slot_4": null,
			 "slot_5": null,
			 "slot_6": null}

var party_num = 3; 		# How many party members are in current room

var enemy_num = 3;	 	# How many enemies in current room
var boss_spawn = false;	# Whether a Mega Knight will spawn

# holds the values that will determine what attribute the enemy will have
var attribute_list = ["wither", "fire", "earth", "air", "water"] # Determine the current attributee
var attribute = "none"

func _ready() -> void:
	enemy_spawn()
	party_spawn()

#region CHARACTER INITIATION
func party_spawn() -> void:
	# determine what monsters are currently available for spawning
	for i in range(party_num):
		var character_class = ["knight", "rogue", "wizard", "cleric", "alchemist"]
		var character = character_class[randi_range(0, 4)]
		init_character_instance(CHARACTER_SCENE.instantiate(), character)

func get_character_stats(_class) -> Array:
	# assigns different stats based on class type
	# each list holds [health, attack, defense, speed]
	match (_class):
		"knight":
			return [14, 2]
		"rogue":
			return [6, 0]
		"wizard":
			return [8, 0]
		"alchemist":
			return [10, 0]
		"cleric":
			return [12, 0]
	return []

func init_character_instance(id, _class) -> void:
	# assign stats based on class type to the new isntance of character
	var stats = get_character_stats(_class)
	id.health = stats[0]
	id.defense = stats[1]
	id.character_class = _class;
	
	# place the character in the correct slot
	var slot = 0
	if (slots["slot_1"] == null): 
		slot = 1
		slots["slot_1"] = id;
	elif (slots["slot_2"] == null): 
		slot = 2
		slots["slot_2"] = id;
	elif (slots["slot_3"] == null): 
		slot = 3
		slots["slot_3"] = id;
	id.slot = slot
	
	# add the enemy to the current main node tree as a child
	add_child(id)

#endregion

#region ENEMY INITIATION

# INIT
func enemy_spawn() -> void:
	# change to random seed
	randomize();
	
	# check for mega knight spawn
	check_boss_spawn(randi_range(0, 19), 19, "mega_knight")
	
	# check for dragon spawning
	check_boss_spawn(randi_range(0, 3), 3, "dragon")

	# determine what monsters are currently available for spawning
	if (boss_spawn == false):
		for i in range(enemy_num):
			# determine the attribute the enemy will have
			var attribute_chance = randi_range(0, 10)
			if (attribute_chance == 10):
				var c = randi_range(0, 4)
				attribute = attribute_list[c];
			else:
				attribute = "none"
			
			if (current_level == 1):
				init_enemy_instance(ENEMY_SCENE.instantiate(), ["skeleton"], attribute, 0)
			elif (current_level == 2):
				init_enemy_instance(ENEMY_SCENE.instantiate(), ["skeleton", "zombie"], attribute, 1)
			elif (current_level == 3):
				init_enemy_instance(ENEMY_SCENE.instantiate(), ["skeleton", "zombie", "goblin"], attribute, 2)
			elif (current_level == 4):
				init_enemy_instance(ENEMY_SCENE.instantiate(), ["zombie", "goblin"], attribute, 1)
			elif (current_level >= 5 && current_level <= 7):
				init_enemy_instance(ENEMY_SCENE.instantiate(), ["goblin", "raider"], attribute, 1)
			elif (current_level >= 8 && current_level <= 11):
				init_enemy_instance(ENEMY_SCENE.instantiate(), ["raider", "orc"], attribute, 1)
			elif (current_level > 11):
				init_enemy_instance(ENEMY_SCENE.instantiate(), ["orc", "troll", "golem"], attribute, 2)

func check_boss_spawn(chance, desired_chance, type) -> void:
	# chance should be a randi_range and desired chance should be the highest value 
	# passed in chance
	if (chance == desired_chance):
		if (type == "dragon"):
			if (current_level > 11):
				boss_spawn = true;
				# handle dragon spawning
				enemy_num = 1
				init_enemy_instance(ENEMY_SCENE.instantiate(), [type], attribute, 0)
		else:
			boss_spawn = true;
			# handle other boss spawning
			enemy_num = 1
			init_enemy_instance(ENEMY_SCENE.instantiate(), [type], attribute, 0)

func get_enemy_stats(_type) -> Array:
	# assigns different stats based on monster type
	# each list holds [health, attack, defense, speed]
	match (_type):
		"skeleton":
			return [4, 2, 0]
		"zombie":
			return [6, 2, 0]
		"goblin":
			return [9, 2, 0]
		"raider":
			return [10, randi_range(3, 4), 0]
		"orc":
			return [14, randi_range(3, 4), 0]
		"troll":
			return [18, randi_range(3,4), 0]
		"golem":
			return [40, 2, 0]
		"dragon":
			return [30, 5, 0]
		"mega_knight": 
			return [30, 3, 0]
	return []

func init_enemy_instance(id, _type, _attribute, _chance) -> void:
	var chance = 0
	if (_chance != 0):
		chance = randi_range(0, _chance)
	else:
		chance = 0
	var type = _type[chance]
	
	# assign stats based on monster type to the new isntance of enemy
	var stats = get_enemy_stats(type)
	id.health = stats[0]
	id.attack = stats[1]
	id.defense = stats[2]
	id.attribute = _attribute;
	id.type = type;
	
	# place the enemy in the correct slot
	var slot = 0
	if (boss_spawn == true):
		slot = 2
		slots["slot_5"] = id;
	else:
		if (slots["slot_4"] == null): 
			slot = 1
			slots["slot_4"] = id;
		elif (slots["slot_5"] == null): 
			slot = 2
			slots["slot_5"] = id;
		elif (slots["slot_6"] == null): 
			slot = 3
			slots["slot_6"] = id;
	id.slot = slot
	
	# add the enemy to the current main node tree as a child
	add_child(id)

func _process(_delta: float) -> void:
	if (Input.is_action_pressed("Debug_Quit")):
		get_tree().quit()
#endregion
