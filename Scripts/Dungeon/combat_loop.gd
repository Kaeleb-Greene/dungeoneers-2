extends Node2D

# preload the scenes
const ENEMY_SCENE = preload("res://Scenes/enemy.tscn")
const CHARACTER_SCENE = preload("res://Scenes/party_character.tscn")

# preload the script for generation
var transitions = preload("res://Scripts/Control/transition.gd").new()
var dungeon_gen = preload("res://Scripts/Dungeon/dungeon_gen.gd").new()

# get the HUD and card slots
@onready var CARD_1: Button = $HUD/CardSlot1
@onready var CARD_2: Button = $HUD/CardSlot2
@onready var CARD_3: Button = $HUD/CardSlot3
@onready var CONTROL: Panel = $HUD

var current_level_index: int = 0
var current_level_data: Node = null

enum CombatState {
	IDLE,
	PLAYER_INPUT,
	ENEMY_DELAY
}

var selected_party: Array[String] = [
	"knight",
	"wizard",
	"rogue"
]

var party: Dictionary = {
	"party_1": null,
	"party_2": null,
	"party_3": null
}

var combat_state: CombatState = CombatState.IDLE
var combat_loop = true;

var active_character: Node = null

var party_queue: Array[Node] = []
var enemy_queue: Array[Node] = []
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
	
	# party spawning
	spawn_party()
	
	#level creation
	init_new_room()
	
	active_character = turn_queue[0]
	start_current_turn()

func init_new_room():
	#get the level index
	current_level_index = dungeon_gen.current_level % 5
	print(current_level_index)
	current_level_data = get_node("Level"+str(current_level_index))
	
	if (current_level_index > 0) && (current_level_index != 0):
		spawn_enemies()
	else:
		spawn_boss()

func spawn_party() -> void:
	#party spawning
	for i in selected_party.size():
		var character = CHARACTER_SCENE.instantiate()
		
		character = dungeon_gen.character_spawn(character, selected_party[i])
		add_child(character)
		
		party["party_"+str(i+1)] = character
		party_queue.append(character)
		turn_queue.append(character)

func spawn_enemies() -> void:
	for i in range(3):
		var enemy = dungeon_gen.enemy_spawn(ENEMY_SCENE.instantiate())
		add_child(enemy)
		turn_queue.append(enemy)
		
func spawn_boss() -> void:
	var enemy = dungeon_gen.enemy_spawn(ENEMY_SCENE.instantiate())
	add_child(enemy)
	enemy_queue.append(enemy)
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
	elif actor.is_in_group("Enemy"):
		combat_state = CombatState.ENEMY_DELAY
		print("Waiting for enemy: ", actor.type)
		enemy_turn_timer.start()
		
	else:
		push_error("Character belongs to neither Party or Enemy combat group")

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
	
	target.modulate = Color(1, 0, 0, 0.25)
	
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
		
	target.modulate = Color(1, 0, 0, 0.25)
		
	#Choose an available monster card
	var available_cards: int = enemy.get_available_cards()
	print("Available Cards: "+str(available_cards))
	
	if available_cards <= 0:
		advance_turn()
		return
		
	var card_num: int = randi_range(1, available_cards)
	var enemy_card_key: String = enemy.cards.get("card_"+str(card_num), "")
	
	print(enemy_card_key)
	
	if (!enemy_card_key.is_empty()):
		print(enemy.type, " uses", enemy_card_key)
		CONTROL.use_card(enemy_card_key, target)
	else:
		push_error("Enemy has no card assigned to slot", card_num)
	
	advance_turn()

func advance_turn():
	check_room_finish(false)
	
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
	
	for enemy in enemy_queue:
		if is_instance_valid(enemy):
			enemy.queue_free()
			
	turn_queue.clear()
	enemy_queue.clear()
	
	for character in party_queue:
		if (is_instance_valid(character)):
			if (!character.is_queued_for_deletion()):
				turn_queue.append(character)
	
	active_character = null
	card_key = ""

func check_room_finish(boss: bool) -> void:
	if (!is_inside_tree()):
		return
		
	var remaining_enemies := []
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if (is_instance_valid(enemy)) && (!enemy.is_queued_for_deletion()):
			remaining_enemies.append(enemy)
	
	if (!remaining_enemies.is_empty()):
		print("ENEMIES STILL EXIST IN ROOM")
		return
		
	clear_room()
	
	dungeon_gen.current_level += 1;
	print("Current Level: "+str(dungeon_gen.current_level))
	dungeon_gen.reset_slots()
	
	if (boss):
		transitions.go_to_shop(get_tree())
		return
	
	init_new_room()
	
	active_character = turn_queue[0]
	combat_loop = true
	start_current_turn()

func _process(_delta: float):
	if (Input.is_action_just_pressed("Debug_Quit")):
		get_tree().quit()
		
