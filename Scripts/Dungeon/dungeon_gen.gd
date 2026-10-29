extends Resource

@export var current_level: int = 1

# slots that will hold information for each enemy and character instance
var party_slots: Dictionary = {
			 "slot_1": null, #1-3 used for player party
			 "slot_2": null,
			 "slot_3": null,
			 "slot_4": null, # 4-6 used for summons
			 "slot_5": null,
			 "slot_6": null
			}

var enemy_slots: Dictionary = {
			 "slot_1": null, # 1-3 used for main enemies
			 "slot_2": null,
			 "slot_3": null,
			 "slot_4": null, # 4-6 used for summons
			 "slot_5": null,
			 "slot_6": null
			}

# holds the values that will determine what attribute the enemy will have
var rooms: Array = ["crypt", "swamp", "cursed_tomb", "enchanted_library", "hellscape", "frozen_cavern", "dragons_den"]
var room_type: String = "crypt"

func reset_enemy_slots():
	enemy_slots = {
		"slot_1": null,
		"slot_2": null,
		"slot_3": null,
		"slot_4": null,
		"slot_5": null,
		"slot_6": null
	}

#region ENTITY INITIATION

# INIT
func entity_spawn(id, _party_spawn: bool, _class_type: String):
	if (_party_spawn):
		id.add_to_group("Party")
		init_entity_instance(id, [_class_type], 0)
		return id
	else:
		id.add_to_group("Enemy")
	# change to random seed
	randomize();

	# determine what monsters are currently available for spawning based on the room type
	# check whether it is a 5th level (every 5 levels is a boss battle)
	if (current_level%5 != 0):
		match (room_type):
			"crypt":
				init_entity_instance(id, ["skeleton", "zombie", "skeleton", "zombie", "raider"], 4)
			"swamp":
				init_entity_instance(id, ["goblin", "orc", "troll"], 2)
			"cursed_tomb":
				init_entity_instance(id, ["pharaoh", "scarab_beetle", "cobra"], 2)
			"enchanted_library":
				init_entity_instance(id, ["dark_wizard", "evil_librarian", "cultist"], 2)
			"hellscape":
				init_entity_instance(id, ["flying_demon", "lava_frog", "fire_serpent"], 2)
			"frozen_cavern":
				init_entity_instance(id, ["frost_troll", "mammoth", "sabertooth_tiger"], 2)
			"dragons_den":
				init_entity_instance(id, ["drake", "kobald"], 1)
	else:
		match (room_type):
			"crypt":
				init_entity_instance(id, ["mega_knight"], 0)
			"swamp":
				init_entity_instance(id, ["ogre"], 0)
			"cursed_tomb":
				init_entity_instance(id, ["anubis_acolyte"], 0)
			"enchanted_library":
				init_entity_instance(id, ["golem"], 0)
			"hellscape":
				init_entity_instance(id, ["hellhound"], 0)
			"frozen_cavern":
				init_entity_instance(id, ["yeti"], 0)
			"dragons_den":
				init_entity_instance(id, ["dragon"], 0)
	return id

func get_entity_stats(_type) -> Array:
	# assigns different stats based on monster type
	# each list holds [health, attack, defense]
	match (_type):
		#region PARTY
		"knight":
			return [14, 4, 2, ["basic_attack", "heavy_attack", "basic_heal"]]
		"rogue":
			return [6, 4, 0, ["heavy_attack", "heavy_attack", "basic_heal"]]
		"wizard":
			return [8, 4, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"alchemist":
			return [10, 4, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"cleric":
			return [12, 4, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		#endregion
		
		#region MONSTER
		
		#CRYPT
		"skeleton":
			return [4, 2, 0, ["shoot_arrow", "shoot_arrow", "shoot_arrow"]]
		"zombie":
			return [6, 2, 0, ["bite", "bite", "bite"]]
		"raider":
			return [10, randi_range(3, 4), 0, ["rally", "raider_axe_throw", "shoot_bolt"]]	
		"mega_knight": 
			return [30, 3, 0, ["mega_strike", "mega_strike", "mega_heal"]]
		
		#SWAMP
		"goblin":
			return [9, 2, 0, ["dagger_throw", "dagger_throw", "poison_strike"]]
		"orc":
			return [14, randi_range(3, 4), 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"troll":
			return [18, randi_range(3,4), 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"ogre": 
			return [30, 3, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		
		#CURSED TOMB
		"pharaoh":
			return [9, 2, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"mummy":
			return [4, 2, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"scarab_beetle":
			return [14, randi_range(3, 4), 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"cobra":
			return [18, randi_range(3,4), 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"anubis_acolyte": 
			return [30, 3, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		
		#ENCHANTED LIBRARY
		"dark_wizard":
			return [9, 2, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"cursed_book":
			return [4, 2, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"evil_librarian":
			return [14, randi_range(3, 4), 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"cultist":
			return [18, randi_range(3,4), 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"golem":
			return [40, 2, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
			
		#HELLSCAPE
		"flying_demon":
			return [9, 2, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"fire_imp":
			return [4, 2, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"lava_frog":
			return [14, randi_range(3, 4), 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"fire_serpent":
			return [18, randi_range(3,4), 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"hellhound":
			return [40, 2, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		
		#FROZEN CAVERN
		"frost_troll":
			return [9, 2, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"mammoth":
			return [14, randi_range(3, 4), 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"sabertooth_tiger":
			return [18, randi_range(3,4), 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"yeti":
			return [40, 2, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		
		#DRAGONS DEN
		"kobald":
			return [18, randi_range(3,4), 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"drake":
			return [40, 2, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		"dragon":
			return [30, 5, 0, ["basic_attack", "heavy_attack", "basic_heal"]]
		
		#endregion
		
	return []

func init_entity_instance(id, _type, _chance) -> void:
	var chance: int = 0
	if (_chance != 0):
		chance = randi_range(0, _chance)
	else:
		chance = 0
	var type: String = _type[chance]
	
	# assign stats based on monster type to the new isntance of enemy
	var stats: Array = get_entity_stats(type)
	id.stats[0] = stats[0]
	id.stats[1] = stats[1]
	id.stats[2] = stats[2]
	id.cards["card_1"] = stats[3][0]
	id.cards["card_2"] = stats[3][1]
	id.cards["card_3"] = stats[3][2]
	id.type = type;
	
	# place the enemy in the correct slot
	var slot: int = 0
	if (id.is_in_group("Party")): 
		if (party_slots.slot_1 == null): 
			slot = 1
			party_slots.slot_1 = id;
		elif (party_slots["slot_2"] == null): 
			slot = 2
			party_slots["slot_2"] = id;
		elif (party_slots["slot_3"] == null): 
			slot = 3
			party_slots["slot_3"] = id;
		elif (party_slots["slot_4"] == null): 
			slot = 4
			party_slots["slot_4"] = id;
		elif (party_slots["slot_5"] == null): 
			slot = 5
			party_slots["slot_5"] = id;
		elif (party_slots["slot_6"] == null): 
			slot = 6
			party_slots["slot_6"] = id;
		if (slot != 0):
			id.slot = slot
		else:
			push_error("Could not assign a slot to: "+str(type))
			id.queue_free()
		
	elif (id.is_in_group("Enemy")):
		if (enemy_slots.slot_1 == null): 
			slot = 1
			enemy_slots.slot_1 = id;
		elif (enemy_slots["slot_2"] == null): 
			slot = 2
			enemy_slots["slot_2"] = id;
		elif (enemy_slots["slot_3"] == null): 
			slot = 3
			enemy_slots["slot_3"] = id;
		elif (enemy_slots["slot_4"] == null): 
			slot = 4
			enemy_slots["slot_4"] = id;
		elif (enemy_slots["slot_5"] == null): 
			slot = 5
			enemy_slots["slot_5"] = id;
		elif (enemy_slots["slot_6"] == null): 
			slot = 6
			enemy_slots["slot_6"] = id;
		if (slot != 0):
			id.slot = slot
		else:
			push_error("Could not assign a slot to: "+str(type))
			id.queue_free()
			return
		
#endregion
