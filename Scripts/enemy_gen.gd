extends Node2D

const ENEMY_SCENE = preload("res://Scenes/enemy.tscn")

@export var current_level = randi_range(1, 20)
var enemy_num = 3;	 			# How many enemies in current room
var boss_spawn = false;	# Whether a Mega Knight will spawn

var slot_1 = null
var slot_2 = null
var slot_3 = null

var attribute_list = ["wither", "fire", "earth", "air", "water"] # Determine the current attributee
var attribute = "none"

# INIT
func _ready() -> void:
	# change to random seed
	randomize();
	
	# determine the attribute of the room
	var attribute_chance = randi_range(0, 1)
	if (attribute_chance == 1):
		var c = randi_range(0, 4)
		attribute = attribute_list[c];
	
	# check for mega knight spawn
	check_boss_spawn(randi_range(0, 19), 19, "mega_knight", attribute)
	
	# check for dragon spawning
	check_boss_spawn(randi_range(0, 3), 3, "dragon", attribute)
		
	# determine what monsters are currently available for spawning
	if (boss_spawn == false):
		for i in range(enemy_num):
			if (current_level == 1):
				enemy_spawn(["skeleton"], 0, attribute);
			elif (current_level == 2):
				enemy_spawn(["skeleton", "zombie"], 1, attribute);
			elif (current_level == 3):
				enemy_spawn(["skeleton", "zombie", "goblin"], 2, attribute);
			elif (current_level == 4):
				enemy_spawn(["zombie", "goblin"], 1, attribute);
			elif (current_level == 5 || current_level == 6):
				enemy_spawn(["goblin", "raider"], 1, attribute);
			elif (current_level >= 8 && current_level < 11):
				enemy_spawn(["raider", "orc"], 1, attribute);
			elif (current_level > 11):
				enemy_spawn(["orc", "troll", "golem"], 2, attribute);

func check_boss_spawn(chance, desired_chance, type, attribute) -> void:
	if (chance == desired_chance):
		if (type == "dragon"):
			if (current_level > 11):
				boss_spawn = true;
				# handle dragon spawning
				enemy_num = 1
				enemy_spawn([type], 0, attribute)
		else:
			boss_spawn = true;
			# handle other boss spawning
			enemy_num = 1
			enemy_spawn([type], 0, attribute)

func get_stats(_type) -> Array:
	#Assigns different stats based on monster type
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

func init_enemy_instance(id, type, _attribute, slot) -> void:
	var stats = get_stats(type)
	print(stats)
	id.health = stats[0]
	id.attack = stats[1]
	id.defense = stats[2]
	id.attribute = _attribute;
	id.slot = slot
	match slot:
		1: 
			slot_1 = id;
			id.position = Vector2(100, 100)
		2: slot_2 = id;
		3: slot_3 = id;
	add_child(id)

func enemy_spawn(_type, _chance, _attribute) -> void:
	var chance = 0
	if (_chance != 0):
		chance = randi_range(0, _chance)
	else:
		chance = 0
	var type = _type[chance]
	var slot = null
	
	print("Current Level: "+str(current_level))
	print("Enemy: "+_attribute + " " + type)
	
	if (boss_spawn == true):
		slot = 2
	else:
		if (slot_1 == null): slot = 1;
		elif (slot_2 == null): slot = 2;
		elif (slot_3 == null): slot = 3;
	init_enemy_instance(ENEMY_SCENE.instantiate(), type, _attribute, slot)

func _process(delta: float) -> void:
	if (Input.is_action_pressed("Debug_Quit")):
		get_tree().quit()
