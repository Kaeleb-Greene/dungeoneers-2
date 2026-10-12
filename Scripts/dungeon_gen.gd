extends Resource

@export var current_level: int = 1

# slots that will hold information for each enemy and character instance
var slots: Dictionary = {"slot_1": null,
			 "slot_2": null,
			 "slot_3": null,
			 "slot_4": null,
			 "slot_5": null,
			 "slot_6": null}

var party_num: int = 3; 		# How many party members are in current room

# holds the values that will determine what attribute the enemy will have
var rooms: Array = ["crypt", "swamp", "cursed_tomb", "enchanted_library", "hellscape", "frozen_cavern", "dragons_den"]
var room_type: String = "crypt"

#region CHARACTER INITIATION
func character_spawn(id, character_class):
	# assign stats based on class type to the new isntance of character
	var stats: Array = get_character_stats(character_class)
	id.health = stats[0]
	id.defense = stats[1]
	id.character_class = character_class;
	
	# place the character in the correct slot
	var slot: int = 0
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


#endregion

#region ENEMY INITIATION

# INIT
func enemy_spawn(id):
	# change to random seed
	randomize();

	# determine what monsters are currently available for spawning based on the room type
	# check whether it is a 5th level (every 5 levels is a boss battle)
	if (current_level%5 != 0):
		if (room_type == "crypt"):
			init_enemy_instance(id, ["skeleton", "zombie", "raider"], 2, false)
		elif (room_type == "swamp"):
			init_enemy_instance(id, ["goblin", "orc", "troll"], 2, false)
		elif (room_type == "cursed_tomb"):
			init_enemy_instance(id, ["pharaoh", "scarab_beetle", "cobra"], 2, false)
		elif (room_type == "enchanted_library"):
			init_enemy_instance(id, ["dark_wizard", "evil_librarian", "cultist"], 2, false)
		elif (room_type == "hellscape"):
			init_enemy_instance(id, ["flying_demon", "lava_frog", "fire_serpent"], 2, false)
		elif (room_type == "frozen_cavern"):
			init_enemy_instance(id, ["frost_troll", "mammoth", "sabertooth_tiger"], 2, false)
		elif (room_type == "dragons_den"):
			init_enemy_instance(id, ["drake", "kobald"], 2, false)
	else:
		if (room_type == "crypt"):
			init_enemy_instance(id, ["mega_knight"], 0, true)
		elif (room_type == "swamp"):
			init_enemy_instance(id, ["ogre"], 0, true)
		elif (room_type == "cursed_tomb"):
			init_enemy_instance(id, ["anubis_acolyte"], 0, true)
		elif (room_type == "enchanted_library"):
			init_enemy_instance(id, ["golem"], 0, true)
		elif (room_type == "hellscape"):
			init_enemy_instance(id, ["hellhound"], 0, true)
		elif (room_type == "frozen_cavern"):
			init_enemy_instance(id, ["yeti"], 0, true)
		elif (room_type == "dragons_den"):
			init_enemy_instance(id, ["dragon"], 0, true)
	return id

func get_enemy_stats(_type) -> Array:
	# assigns different stats based on monster type
	# each list holds [health, attack, defense]
	match (_type):
		
		#CRYPT
		"skeleton":
			return [4, 2, 0]
		"zombie":
			return [6, 2, 0]
		"raider":
			return [10, randi_range(3, 4), 0]	
		"mega_knight": 
			return [30, 3, 0]
		
		#SWAMP
		"goblin":
			return [9, 2, 0]
		"orc":
			return [14, randi_range(3, 4), 0]
		"troll":
			return [18, randi_range(3,4), 0]
		"ogre": 
			return [30, 3, 0]
		
		#CURSED TOMB
		"pharaoh":
			return [9, 2, 0]
		"mummy":
			return [4, 2, 0]
		"scarab_beetle":
			return [14, randi_range(3, 4), 0]
		"cobra":
			return [18, randi_range(3,4), 0]
		"anubis_acolyte": 
			return [30, 3, 0]
		
		#ENCHANTED LIBRARY
		"dark_wizard":
			return [9, 2, 0]
		"cursed_book":
			return [4, 2, 0]
		"evil_librarian":
			return [14, randi_range(3, 4), 0]
		"cultist":
			return [18, randi_range(3,4), 0]
		"golem":
			return [40, 2, 0]
			
		#HELLSCAPE
		"flying_demon":
			return [9, 2, 0]
		"fire_imp":
			return [4, 2, 0]
		"lava_frog":
			return [14, randi_range(3, 4), 0]
		"fire_serpent":
			return [18, randi_range(3,4), 0]
		"hellhound":
			return [40, 2, 0]
		
		#FROZEN CAVERN
		"frost_troll":
			return [9, 2, 0]
		"mammoth":
			return [14, randi_range(3, 4), 0]
		"sabertooth_tiger":
			return [18, randi_range(3,4), 0]
		"yeti":
			return [40, 2, 0]
		
		#DRAGONS DEN
		"kobald":
			return [18, randi_range(3,4), 0]
		"drake":
			return [40, 2, 0]
		"dragon":
			return [30, 5, 0]
	return []

func init_enemy_instance(id, _type, _chance, boss_spawn) -> void:
	var chance: int = 0
	if (_chance != 0):
		chance = randi_range(0, _chance)
	else:
		chance = 0
	var type: String = _type[chance]
	
	# assign stats based on monster type to the new isntance of enemy
	var stats: Array = get_enemy_stats(type)
	id.health = stats[0]
	id.attack = stats[1]
	id.defense = stats[2]
	id.type = type;
	
	# place the enemy in the correct slot
	var slot: int = 0
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
