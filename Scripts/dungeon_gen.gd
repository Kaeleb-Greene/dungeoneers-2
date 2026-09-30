extends RefCounted

@export var current_level = randi_range(1, 20)

# slots that will hold information for each enemy and character instance
var slots = {"slot_1": null,
			 "slot_2": null,
			 "slot_3": null,
			 "slot_4": null,
			 "slot_5": null,
			 "slot_6": null}

var party_num = 3; 		# How many party members are in current room

# holds the values that will determine what attribute the enemy will have
var attribute_list = ["wither", "fire", "earth", "air", "water"] # Determine the current attributee
var attribute = "none"

#region CHARACTER INITIATION
func character_spawn(id, character_class):
	# Spawn the character for player party
	init_character_instance(id, character_class)
	return id

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
	

#endregion

#region ENEMY INITIATION

# INIT
func enemy_spawn(id, mega_knight_spawn, dragon_spawn):
	# change to random seed
	randomize();
	
	# check for mega knight spawn
	if (mega_knight_spawn):
		init_enemy_instance(id, ["mega_knight"], attribute, 0, true)
	
	# check for dragon spawning
	if (dragon_spawn):
		init_enemy_instance(id, ["dragon"], attribute, 0, true)

	# determine what monsters are currently available for spawning
	if (!dragon_spawn && !mega_knight_spawn):
		# determine the attribute the enemy will have
		var attribute_chance = randi_range(0, 10)
		if (attribute_chance == 10):
			var c = randi_range(0, 4)
			attribute = attribute_list[c];
		else:
			attribute = "none"
		
		if (current_level == 1):
			init_enemy_instance(id, ["skeleton"], attribute, 0, false)
		elif (current_level == 2):
			init_enemy_instance(id, ["skeleton", "zombie"], attribute, 1, false)
		elif (current_level == 3):
			init_enemy_instance(id, ["skeleton", "zombie", "goblin"], attribute, 2, false)
		elif (current_level == 4):
			init_enemy_instance(id, ["zombie", "goblin"], attribute, 1, false)
		elif (current_level >= 5 && current_level <= 7):
			init_enemy_instance(id, ["goblin", "raider"], attribute, 1, false)
		elif (current_level >= 8 && current_level <= 11):
			init_enemy_instance(id, ["raider", "orc"], attribute, 1, false)
		elif (current_level > 11):
			init_enemy_instance(id, ["orc", "troll", "golem"], attribute, 2, false)
	return id

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

func init_enemy_instance(id, _type, _attribute, _chance, boss_spawn) -> void:
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
	if (boss_spawn):
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
#endregion

func get_slots():
	return slots
