extends Node2D

const ENEMY_SCENE = preload("res://Scenes/enemy.tscn")

@export var current_level = randi_range(1, 20)
var enemy_num = 3;	 	# How many enemies in current room
var boss_spawn = false;	# Whether a Mega Knight will spawn

# slots that will hold information for each enemy instance
var slot_1 = null
var slot_2 = null
var slot_3 = null

# holds the values that will determine what attribute the enemy will have
var attribute_list = ["wither", "fire", "earth", "air", "water"] # Determine the current attributee
var attribute = "none"

# INIT
func _ready() -> void:
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

func get_stats(_type) -> Array:
	# assigns different stats based on monster type
	# each list holds [health, attack, defense, speed]
	match (_type):
		"skeleton":
			return [4, 2, 0, 1]
		"zombie":
			return [6, 2, 0, 1]
		"goblin":
			return [9, 2, 0, 1]
		"raider":
			return [10, randi_range(3, 4), 0, 1]
		"orc":
			return [14, randi_range(3, 4), 0, 1]
		"troll":
			return [18, randi_range(3,4), 0, 1]
		"golem":
			return [40, 2, 0, 1]
		"dragon":
			return [30, 5, 0, 1]
		"mega_knight": 
			return [30, 3, 0, 1]
	return []

func init_enemy_instance(id, _type, _attribute, _chance) -> void:
	var chance = 0
	if (_chance != 0):
		chance = randi_range(0, _chance)
	else:
		chance = 0
	var type = _type[chance]
	
	# assign stats based on monster type to the new isntance of enemy
	var stats = get_stats(type)
	id.health = stats[0]
	id.attack = stats[1]
	id.defense = stats[2]
	id.speed = stats[3]
	id.attribute = _attribute;
	id.type = type;
	
	# place the enemy in the correct slot
	var slot = 0
	if (boss_spawn == true):
		slot = 2
		slot_2 = id;
	else:
		if (slot_1 == null): 
			slot = 1
			slot_1 = id;
		elif (slot_2 == null): 
			slot = 2
			slot_2 = id;
		elif (slot_3 == null): 
			slot = 3
			slot_3 = id;
	id.slot = slot
	
	# add the enemy to the current main node tree as a child
	add_child(id)

func _process(_delta: float) -> void:
	if (Input.is_action_pressed("Debug_Quit")):
		get_tree().quit()
