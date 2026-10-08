extends Node2D

# preload the scenes
const ENEMY_SCENE = preload("res://Scenes/enemy.tscn")
const CHARACTER_SCENE = preload("res://Scenes/party_character.tscn")

# preload the script for generation
var dungeon_gen = preload("res://Scripts/dungeon_gen.gd").new()

# get the HUD and card slots
@onready var CARD_1: Button = get_node("/root/Dungeon/HUD/CardSlot1")
@onready var CARD_2: Button = get_node("/root/Dungeon/HUD/CardSlot2")
@onready var CARD_3: Button = get_node("/root/Dungeon/HUD/CardSlot3")
@onready var CONTROL: Panel = get_node("/root/Dungeon/HUD")

var active_character = null

var turn_queue = []
signal card_used
var card_index: int = 0;
var combat_loop = true;

func _ready() -> void:
	init_new_room()
	
	CARD_1.pressed.connect(on_button_press)
	CARD_2.pressed.connect(on_button_press)
	CARD_3.pressed.connect(on_button_press)
	
	active_character = turn_queue[0]
	
	play_turn()

func init_new_room():
	# party spawning
	var character = dungeon_gen.character_spawn(CHARACTER_SCENE.instantiate(), "knight")
	add_child(character)
	turn_queue.append(character)
	character = dungeon_gen.character_spawn(CHARACTER_SCENE.instantiate(), "rogue")
	add_child(character)
	turn_queue.append(character)
	character = dungeon_gen.character_spawn(CHARACTER_SCENE.instantiate(), "wizard")
	add_child(character)
	turn_queue.append(character)
	
	# enemy spawning
	for i in range(3):
		var enemy = dungeon_gen.enemy_spawn(ENEMY_SCENE.instantiate())
		add_child(enemy)
		turn_queue.append(enemy)

func play_turn():
	while combat_loop:
		await card_used
		print(card_index)
		var target: Node = get_target()
		if (is_instance_valid(target)):
			CONTROL.use_card(active_character, target, card_index)
		var new_index: int = (active_character.get_index() + 1) % turn_queue.size()
		active_character = turn_queue[new_index]

func on_button_press():
	if (CARD_1.button_pressed):
		card_index = 0;
		card_used.emit()
	if (CARD_2.button_pressed):
		card_index = 1;
		card_used.emit()
	if (CARD_3.button_pressed):
		card_index = 2;
		card_used.emit()
	
func get_target() -> Node:
	for target in turn_queue:
		if (is_instance_valid(target)):
			if target.is_in_group("Enemy"):
				return target
	return null

func _process(delta: float):
	if (Input.is_action_just_pressed("Debug_Increase_Current_Room")):
		for child in get_children():
			if (is_in_group("Party")):
				queue_free()
			elif (is_in_group("Enemy")):
				queue_free()		
		dungeon_gen.current_level += 1;
		print("Current Level: "+str(dungeon_gen.current_level))
		init_new_room()
