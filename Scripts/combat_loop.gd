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

enum CombatState {
	IDLE,
	PLAYER_INPUT,
	ENEMY_DELAY
}

var combat_state: CombatState = CombatState.IDLE
var combat_loop = true;

var active_character: Node = null
var turn_queue: Array[Node] = []
var card_key: String

var enemy_turn_timer: Timer

func _ready() -> void:
	#Create a timer for enemy turns
	enemy_turn_timer = Timer.new()
	enemy_turn_timer.wait_time = 1
	enemy_turn_timer.one_shot = true
	add_child(enemy_turn_timer)
	
	enemy_turn_timer.timeout.connect(_on_enemy_turn_timer_timeout)
	
	#Connect button presses
	CARD_1.pressed.connect(on_button_press.bind(0))
	CARD_2.pressed.connect(on_button_press.bind(1))
	CARD_3.pressed.connect(on_button_press.bind(2))
	
	init_new_room()
	
	active_character = turn_queue[0]
	start_current_turn()

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

func get_next_character() -> Node:
	turn_queue = turn_queue.filter(
		func(character): return (is_instance_valid(character) && !character.is_queued_for_deletion())
	)
	
	if (turn_queue.is_empty()):
		return null
		
	var current_index = turn_queue.find(active_character)
	
	if (current_index == -1):
		return turn_queue[0]
	
	var next_index = (current_index + 1) % turn_queue.size()
	return turn_queue[next_index]

func start_current_turn():
	if !combat_loop:
		return
	
	#Find Active Character
	active_character = get_valid_active_character()
	
	if active_character == null:
		combat_state = CombatState.IDLE
		combat_loop = false
		print("Combat has ended...")
		return
	
	var actor: Node = active_character
	
	actor.modulate = Color(0, 1, 0, 0.25)
	
	#PLAYER TURN
	if actor.is_in_group("Party"):
		combat_state = CombatState.PLAYER_INPUT
		print("Waiting for player: ", actor.character_class)
	
	#ENEMY TURN
	if actor.is_in_group("Enemy"):
		combat_state = CombatState.ENEMY_DELAY
		print("Waiting for enemy: ", actor.type)
		enemy_turn_timer.start()

func get_valid_active_character() -> Node:
	if (is_instance_valid(active_character)):
		if (!active_character.is_queued_for_deletion()):
			if (turn_queue.has(active_character)):
				return active_character
				
	return get_next_character()

func on_button_press(index):
	#Ingore input outside of player turn
	if (combat_state != CombatState.PLAYER_INPUT):
		return
	
	if !is_instance_valid(active_character) || active_character.is_queued_for_deletion():
		advance_turn()
		return
	
	#Get the card assigned to the clicked slot
	var order_key: String = "current_card_" + str(index + 1)
	
	card_key = CONTROL.card_order.get(order_key, "")
	
	#Check is the slot contains a valid card
	if card_key.is_empty():
		push_error("No cards assigned to this slot.")
		return
	
	#Find an enemy to target
	var target: Node = get_target("Enemy")
	
	if (!is_instance_valid(target)):
		push_error("No valid enemies to target.")
		advance_turn()
		return
		
	#Use the selected card
	CONTROL.use_card(card_key, target)
	
	#Finish player turn
	advance_turn()

func _on_enemy_turn_timer_timeout():
	#only count when in combat
	if !combat_loop:
		return
		
	if combat_state != CombatState.ENEMY_DELAY:
		return
	
	#Verify the enemy still exists
	if !is_instance_valid(active_character) || (active_character.is_queued_for_deletion()):
		advance_turn()
		return
	
	var enemy: Node = active_character
	
	#Find a valid target
	var target: Node = get_target("Party")
	
	if (!is_instance_valid(target)):
		push_error("No valid targets.")
		advance_turn()
		return
		
	#Choose an available monster card
	var available_cards: int = enemy.get_available_cards()
	print("Available Cards: "+str(available_cards))
	
	if available_cards <= 0:
		advance_turn()
		return
		
	var card_num: int = randi_range(1, available_cards)
	var enemy_card_key: String = enemy.cards.get("card_"+str(card_num))
	
	if (!enemy_card_key.is_empty):
		print(enemy.type, " uses", enemy_card_key)
		CONTROL.use_card(enemy_card_key, target)
	else:
		push_error("Enemy has no card assigned to slot", card_num)
	
	advance_turn()

func advance_turn():
	#Cancel any currently active enemy action
	if (is_instance_valid(enemy_turn_timer)):
		enemy_turn_timer.stop()
	
	#Restore the previous active character color
	if (is_instance_valid(active_character)):
		if (!active_character.is_queued_for_deletion()):
			active_character.modulate = Color(1, 1, 1)
	
	if (!combat_loop):
		combat_state = CombatState.IDLE
		return
	
	#Select the next character and begin their turn
	active_character = get_next_character()
	start_current_turn()
	
func get_target(target_affil) -> Node:
	for target in turn_queue:
		if !is_instance_valid(target):
			continue
		
		if target.is_queued_for_deletion():
			continue
		
		if (target.is_in_group(target_affil)):
			return target
			
	return null

func clear_room():
	combat_loop = false
	combat_state = CombatState.IDLE
	
	if (is_instance_valid(enemy_turn_timer)):
		enemy_turn_timer.stop()
	
	for character in turn_queue:
		if is_instance_valid(character):
			character.queue_free()
			
	turn_queue.clear()
	active_character = null
	card_key = ""

func _process(_delta: float):
	if (Input.is_action_just_pressed("Debug_Quit")):
		get_tree().quit()
	
	if (Input.is_action_just_pressed("Debug_Increase_Current_Room")):
		clear_room()
		
		dungeon_gen.current_level += 1;
		print("Current Level: "+str(dungeon_gen.current_level))
		
		dungeon_gen.reset_slots()
		init_new_room()
		
		active_character = turn_queue[0]
		combat_loop = true
		start_current_turn()
