extends Node2D

const ENEMY_SCENE = preload("res://enemy.tscn")

@export var current_level = 1
var enemy_num = 3;	 			# How many enemies in current room
var boss_spawn = false;	# Whether a Mega Knight will spawn

var slot_1 = null
var slot_2 = null
var slot_3 = null

var room_attribute = ["none", "wither", "fire", "earth", "air", "water"] # Determine the current attribute

# INIT
func _ready() -> void:
	# change to random seed
	randomize();
	
	# determine the attribute of the room
	var c = randi_range(0, 5)
	var attribute = room_attribute[c]
	
	# check for mega knight spawn
	var a = randi_range(0, 19)
	if (a == 19):
		boss_spawn = true;
		# handle mega knight spawning
		enemy_num = 1;
		enemy_spawn(["mega_knight"], 0, "none")
	
	# check for dragon spawning
	var d = randi_range(0, 3)
	if (d == 3) && (current_level > 11):
		boss_spawn = true;
		# handle dragon spawning
		enemy_num = 1
		enemy_spawn(["dragon"], 0, attribute)
		
	
	else:
		# determine what monsters are currently available for spawning
		for i in range(enemy_num):
			if (current_level == 1):
				enemy_spawn(["skeleton"], 0, attribute);
			elif (current_level == 2):
				enemy_spawn(["skeleton", "zombie"], 1, attribute);
			elif (current_level == 3):
				enemy_spawn(["skeleton", "zombie", "golbin"], 2, attribute);
			elif (current_level == 4):
				enemy_spawn(["zombie", "golbin"], 1, attribute);
			elif (current_level == 5 || current_level == 6):
				enemy_spawn(["goblin", "raider"], 1, attribute);
			elif (current_level >= 8 || current_level < 11):
				enemy_spawn(["raider", "orc"], 1, attribute);
			elif (current_level > 11):
				enemy_spawn(["orc", "troll", "golem"], 3, attribute);

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


func enemy_spawn(_type, _chance, _attribute) -> void:
	var chance = randi_range(0, _chance)
	var type = _type[chance]
	
	print("Current Level: "+str(current_level))
	print("Enemy: "+_attribute + " " + type)
	
	if (slot_1 == null) && (enemy_num > 1):
		slot_1 = type
		var _enemy_1 = ENEMY_SCENE.instantiate()
		var stats = get_stats(type)
		_enemy_1.health = stats[0]
		_enemy_1.attack = stats[1]
		_enemy_1.defense = stats[2]
		_enemy_1.attribute = _attribute;
		add_child(_enemy_1)
	elif (slot_2 == null):
		slot_2 = type
		var _enemy_2 = ENEMY_SCENE.instantiate()
		var stats = get_stats(type)
		_enemy_2.health = stats[0]
		_enemy_2.attack = stats[1]
		_enemy_2.defense = stats[2]
		_enemy_2.attribute = _attribute;
		add_child(_enemy_2)
	elif (slot_3 == null) && (enemy_num > 1):
		slot_3 = type
		var _enemy_3 = ENEMY_SCENE.instantiate()
		var stats = get_stats(type)
		_enemy_3.health = stats[0]
		_enemy_3.attack = stats[1]
		_enemy_3.defense = stats[2]
		_enemy_3.attribute = _attribute;
		add_child(_enemy_3)
		
