extends Node2D

# preload the scenes
const ENEMY_SCENE = preload("res://Scenes/enemy.tscn")
const CHARACTER_SCENE = preload("res://Scenes/party_character.tscn")

# preload the script for generation
var dungeon_gen = preload("res://Scripts/dungeon_gen.gd").new()

func _ready() -> void:
	# mega knight spawning
	if (randi_range(0, 19) == 19):
		var enemy = dungeon_gen.enemy_spawn(ENEMY_SCENE.instantiate(), true, false)
		add_child(enemy)
		
	# dragon Spawning
	elif (randi_range(0, 3) == 3) && (dungeon_gen.current_level > 11):
		var enemy = dungeon_gen.enemy_spawn(ENEMY_SCENE.instantiate(), false, true)
		add_child(enemy)
	
	else:
		for i in range(3):
			var enemy = dungeon_gen.enemy_spawn(ENEMY_SCENE.instantiate(), false, false)
			add_child(enemy)
	
	# party spawning
	var character_1 = dungeon_gen.character_spawn(CHARACTER_SCENE.instantiate(), "knight")
	add_child(character_1)
	var character_2 = dungeon_gen.character_spawn(CHARACTER_SCENE.instantiate(), "rogue")
	add_child(character_2)
	var character_3 = dungeon_gen.character_spawn(CHARACTER_SCENE.instantiate(), "wizard")
	add_child(character_3)

# get the slot positions for each entitiy after they have initialized
var slots = dungeon_gen.get_slots()

func _process(_delta: float) -> void:
	if (Input.is_action_pressed("Debug_Quit")):
		get_tree().quit()
