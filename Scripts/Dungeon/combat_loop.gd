extends Node2D

# preload the scenes
const CHARACTER_SCENE = preload("res://Scenes/dungeon_character.tscn")

# preload the script for generation
var transitions = preload("res://Scripts/Control/transition.gd").new()
var dungeon_gen = preload("res://Scripts/Dungeon/dungeon_gen.gd").new()

# get the HUD and card slots
@onready var CARD_1: Button = $HUD/CardSlot1
@onready var CARD_2: Button = $HUD/CardSlot2
@onready var CARD_3: Button = $HUD/CardSlot3
@onready var CONTROL: Panel = $HUD

#init current level data
var current_level_index: int = 0
var current_level_data: Node = null
var current_level_is_boss: bool = false

# Will be used to track party types that will be carried in from the character selection menu
var selected_party: Array[String] = [
	"knight",
	"wizard",
	"rogue"
]

#init transition based variables
var room_transitioning: bool = false

#init combat based variables
enum CombatState {
	IDLE,
	PLAYER_INPUT,
	ENEMY_DELAY
}

var combat_state: CombatState = CombatState.IDLE
var combat_loop = true;

var active_character: Node = null
var active_turn_index: int = 0

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
	
	#party spawning
	spawn_party()
	
	#level creation
	init_new_room()
	
	active_character = turn_queue[0]
	start_current_turn()

func init_new_room():
	#get the level index
	current_level_index = dungeon_gen.current_level % 5
	current_level_data = get_node("Level"+str(current_level_index))
	
	current_level_is_boss = (dungeon_gen.current_level % 5 == 0)
	
	#enemy spawning
	if (current_level_index > 0) && (current_level_index != 0):
		spawn_enemies()
	else:
		spawn_boss()

func spawn_party() -> void:
	#party spawning
	for i in selected_party.size():
		#instance the character scene
		var character = dungeon_gen.entity_spawn(CHARACTER_SCENE.instantiate(), true, selected_party[i])
		
		#connect death signal from character_controller
		character.died.connect(_on_character_died)		
		add_child(character)
		
		#Add the character to the active queues
		party_queue.append(character)
		turn_queue.append(character)

func spawn_enemies() -> void:
	for i in range(3):
		#instance the character scene
		var enemy = dungeon_gen.entity_spawn(CHARACTER_SCENE.instantiate(), false, "")
		
		#connect death signal from character_controller
		enemy.died.connect(_on_character_died)
		add_child(enemy)
		
		#Add the character to the active queues
		enemy_queue.append(enemy)
		turn_queue.append(enemy)
		
func spawn_boss() -> void:
	#instance the character scene
	var enemy = dungeon_gen.entity_spawn(CHARACTER_SCENE.instantiate(), false, "")
	
	#connect death signal from character_controller
	enemy.died.connect(_on_character_died)
	add_child(enemy)
	
	#Add the character to the active queues
	enemy_queue.append(enemy)
	turn_queue.append(enemy)

func get_next_character() -> Node:
	#parse through turn_queue and return only the instances that are valid and not queued for deletion
	turn_queue = turn_queue.filter(
		func(character): return (is_instance_valid(character) && !character.is_queued_for_deletion())
	)
	
	if (turn_queue.is_empty()):
		return null
	
	#get the index of the currently active character according to filtered turn_queue
	var current_index = turn_queue.find(active_character)
	
	#Loop logic, return to start if we have exceeded the total number of values in turn_queue
	if (current_index == -1):
		return turn_queue[0]
	
	#increment by one from the current_index 
	var next_index = (current_index + 1) % turn_queue.size()
	return turn_queue[next_index]

func start_current_turn():
	#checks if we are still in combat
	if !combat_loop:
		return
	
	#Find Active Character
	turn_queue = turn_queue.filter(
		func(character): 
		return is_instance_valid(character) \
			and !character.is_queued_for_deletion()
	)
	
	#exit combat if there are no characters in turn_queue
	if (turn_queue.is_empty()):
		active_character = null
		combat_state = CombatState.IDLE
		push_error("There are no more availale characters in the turn queue")
		return
	
	#get the active_turn_index
	active_turn_index = posmod(active_turn_index, turn_queue.size())
	active_character = turn_queue[active_turn_index]
	
	#DEBUG: Light up green when active
	active_character.modulate = Color(0, 1, 0, 0.25)
	
	#PLAYER TURN
	if active_character.is_in_group("Party"):
		combat_state = CombatState.PLAYER_INPUT
	
	#ENEMY TURN
	elif active_character.is_in_group("Enemy"):
		combat_state = CombatState.ENEMY_DELAY
		enemy_turn_timer.start()
		
	else:
		combat_state = CombatState.IDLE
		push_error("Character belongs to neither Party or Enemy combat group")

func get_valid_active_character() -> Node:
	#check if the active_character is valid, is not queued for deletion, and that it is in turn_queue
	if (is_instance_valid(active_character)):
		if (!active_character.is_queued_for_deletion()):
			if (turn_queue.has(active_character)):
				return active_character
	
	#If any of the previous are false it will get a new valid character assuming 
	#there are valid ones left in turn_queue
	return get_next_character()

func on_button_press(index):
	#Ingore input outside of player turn
	if (combat_state != CombatState.PLAYER_INPUT):
		return
	
	#skip this character turn if not valid or queued for deletion
	if !is_instance_valid(active_character) || active_character.is_queued_for_deletion():
		advance_turn()
		return
	
	#check that this character is in correct group
	if (!active_character.is_in_group("Party")):
		return
	
	#Get the card assigned to the clicked slot
	var order_key: String = "current_card_" + str(index + 1)
	card_key = CONTROL.card_order.get(order_key, "")
	
	#Check is the slot contains a valid card
	if card_key.is_empty():
		push_error("No cards assigned to this slot.")
		return
	
	#Find an enemy to target
	#This will be replaced soon to get player input to select enemy not through parsing
	var target: Node = get_target("Enemy")
	
	#Exit if the target is not a valid Node
	if (!is_instance_valid(target)):
		push_error("No valid enemies to target.")
		advance_turn()
		return
	
	#DEBUG: light up the target red
	target.modulate = Color(1, 0, 0, 0.25)
	
	#Use the selected card
	CONTROL.use_card(active_character, card_key, target)
	
	#Finish player turn
	advance_turn()

func _on_enemy_turn_timer_timeout():
	#only count when in combat
	if !combat_loop || combat_state != CombatState.ENEMY_DELAY:
		return
	
	#Verify the enemy still exists
	if !is_instance_valid(active_character) || (active_character.is_queued_for_deletion()):
		advance_turn()
		return
	
	#Set active_character to a local variable
	var enemy: Node = active_character
	
	#Find a valid target
	var target: Node = get_target("Party")
	
	#Exit if the target is not a valid Node
	if (!is_instance_valid(target)):
		push_error("No valid targets.")
		advance_turn()
		return
	
	#DEBUG: Light up the target red
	target.modulate = Color(1, 0, 0, 0.25)
		
	#Choose an available monster card and make sure it is valid
	var available_cards: int = enemy.get_available_cards()
	if available_cards <= 0:
		advance_turn()
		return
	
	#Get the enemy card key from a random selection of their hard coded card types available
	var card_num: int = randi_range(1, available_cards)
	var card_value = enemy.cards.get("card_"+str(card_num), "")
	var enemy_card_key: String = str(card_value) if card_value != null else ""
	
	#Check that we have selected a card
	if (!enemy_card_key.is_empty()):
		CONTROL.use_card(enemy, enemy_card_key, target)
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
			
	#check if we have exited combat and change state accordingly
	if (!combat_loop):
		combat_state = CombatState.IDLE
		return
	
	#exit if turn_queue is empty
	if (turn_queue.is_empty()):
		active_character = null
		combat_state = CombatState.IDLE
		return
	
	var current_index = turn_queue.find(active_character)
	
	# If current_index == -1, the active character was removed.
	# Keep active_turn_index because the next character shifted
	# into that position.
	if current_index != -1:
		active_turn_index = current_index + 1
	
	#Select the next character and begin their turn
	active_character = null
	start_current_turn()
	
func get_target(target_affil) -> Node:
	#Parse through turn_queue for first available target
	#Will be changed later for more advanced enemy AI and greater player input
	for target in turn_queue:
		if !is_instance_valid(target):
			continue
		
		if target.is_queued_for_deletion():
			continue
		
		if (target.is_in_group(target_affil)):
			return target
			
	return null

func _on_character_died(character: Node) -> void:
	var old_index: int = turn_queue.find(character)
	var was_enemy: bool = character.is_in_group("Enemy")
	var was_active := character == active_character
	
	#Remove the instance queued for deletion from the active queues
	turn_queue.erase(character)
	enemy_queue.erase(character)
	party_queue.erase(character)
	
	# Only finish the room when the last enemy dies.
	if was_enemy and enemy_queue.is_empty():
		level_finish()
		return
	
	#Stop the enemy from continuing turn if they are dead
	if (was_active) && (is_instance_valid(enemy_turn_timer)):
		enemy_turn_timer.stop()
		
	# If an earlier position was removed, the current
	# character's index shifts left by one.
	if old_index != -1 && old_index < active_turn_index:
		active_turn_index -= 1
		
	#exit combat if no more valid characters are available
	if (turn_queue.is_empty()):
		active_character = null
		combat_state = CombatState.IDLE
		return
		
		#Assign correct new index so the array doesn't reset when faced with assignment error (-1 -> 0)
	if (was_active):
		var new_index: int = posmod(old_index, turn_queue.size())
		active_character = turn_queue[new_index]
		start_current_turn()
			
func clear_room():
	#Exit combat
	combat_loop = false
	combat_state = CombatState.IDLE
	
	if (is_instance_valid(enemy_turn_timer)):
		enemy_turn_timer.stop()
	
	#clear enemies from room
	for enemy in enemy_queue:
		if is_instance_valid(enemy):
			enemy.queue_free()
			
	#clear queues
	turn_queue.clear()
	enemy_queue.clear()
	
	#Add party back to turn_queue to allow for persistance between levels
	for character in party_queue:
		if (is_instance_valid(character)):
			if (!character.is_queued_for_deletion()):
				turn_queue.append(character)
				
	#reset interactive values
	active_character = null
	card_key = ""

func level_finish() -> void:
	print_rich("[color=green]level_finish is being run")
	#check to make sure we aren't running code outside of the tree
	if (!is_inside_tree()):
		push_error("Cannot finish level as function is being run outside of node tree")
		return
	
	#if we are already transitioning exit
	if (room_transitioning):
		return
		
	room_transitioning = true;
	
	clear_room()
	
	#increment the current_level by 1
	dungeon_gen.current_level += 1;
	print("Current Level: "+str(dungeon_gen.current_level))
	dungeon_gen.reset_enemy_slots()
	
	#go to shop after boss kill
	if (current_level_is_boss):
		transitions.go_to_shop(get_tree())
	
	init_new_room()
	
	#reset loop values
	combat_loop = true
	room_transitioning = false
	
	if turn_queue.is_empty():
		push_error("No characters available to start the next room")
		return
	
	active_character = turn_queue[0]
	start_current_turn()
	
func _process(_delta: float):
	if (Input.is_action_just_pressed("Debug_Quit")):
		get_tree().quit()
