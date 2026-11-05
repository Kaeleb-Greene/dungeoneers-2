extends Panel

#Load the modifier script
var modifier_system = preload("res://Scripts/Dungeon/modifier_control.gd").new()

#[card type, value of card, description, intended target]
var card_def: Dictionary = {
	
	### UNIVERSAL ###
	
	"basic_attack": ["attack", 1.25, "Attacks the enemy for 3 damage", "enemy"],
	"heavy_attack": ["attack", 2, "Attacks the enemy for 6 damage", "enemy"],
	"basic_heal": ["heal", 4, "Heals the target 4 health", "self"],
	
	#region PLAYER
	
	#region TANK
	
	### KNIGHT ###
		"mighty_blow": ["attack", 1, "Strike a heavy blow to an enemy dealing 1.5x dmg, if target is below half hp deal 2x dmg.", "enemy"],
		"swordsmanship": ["buff", 1, "Parry the next attack towards you and deal 1x dmg to the Attacker, if the attackers dmg stat is higher than it fails.", "self"],
		"knights_defense": ["buff", 1, "Shield a party member absorbing the damage for them for 1 turn.", "other_ally"],
	
	### DWARF ###
		"explosive": ["attack", 2, "Build a bomb that does 2x dmg to use on your next turn", "enemy"],
		"dwarven_weaponry": ["buff", .1, "Upgrade a party members dmg by 10%(only can be used once per party member, lasts the remainder of the floor).", "ally"],
		"dwarven_plating": ["buff", .1, "Armor a party member increasing their max health by 10%(only can be used once per party member, lasts the remainder of the floor)", "ally"],
		
	### BARBARIAN ###
		"taunt": ["curse", .5, "Gain the attention of the enemies giving them a 50% chance to target you.", "all_enemies"],
		"enrage": ["buff", .5, "Give a 50% chance on your next attack to hit twice.", "self"],
		"drunken_rage": ["buff", 2, "Go berserk for 2 turns in a row dealing 2x dmg but lose a turn afterwards", "self"],
		
	### NECROMANCER ###
		"arise": ["special", .5, "Summon a skeleton .5x dmg on your turn that attacks randomly (cannot exceed 6 total party members)", "self"],
		"soul_reaping": ["attack", .5, "Deal .5x dmg to an enemy stealing health for yourself", "enemy"],
		"spirit_sacrifice": ["attack", .75, "Destroy all active skeletons attacking for .75x dmg per skeleton", "enemy"],
	
	#endregion
	
	#region DAMAGE

	### WIZARD ###
	"vegas_fireball": ["attack", 1, "Cast a fireball that does either 1 damage or 3x dmg", "enemy"],
	"fireball_maxima": ["attack", 2.5, "Cast a fireball that does .5x dmg to all enemies or has a 20% chance to do 2.5x base damage to all enemies", "all_enemies"],
	"magical_field": ["buff", 1, "Shield yourself in a magical bubble for 1 turns that reflects all incoming attack", "self"],
	
	### ARCHER ###
	"arrow_barrage": ["attack", .5, "Rain down arrows on the enemy with a 50% chance to deal 2x dmg on each enemy. Else: 1.25x damage", "all_enemies"],
	"longshot": ["attack", 2, "Draw your bow back for a heavy shot dealing 2x dmg", "enemy"],
	"freeze_arrow": ["attack", 1, "Does 1x dmg, 25% chance to freeze the enemy for their next turn", "enemy"],
	
	### HUNTSMAN ###
	"mans_best_friend": ["special", 1, "Summon a companion dog with .5x huntsmans max hp that deals 1x dmg every turn to a random enemy", "self"],
	"buckshot": ["attack", 2, "Fire a heavy blow from your rifle dealing 2x base damage", "enemy"],
	"hunters_mark": ["buff", 1.5, "Marked enemy will take 1.5x more dmg from the dog until the enemy is defeated.", "enemy"],
	
	### ROGUE ###
	"shadow_step": ["attack", .5, "Deal .5x base damage to all enemies", "all_enemies"],
	"pick_pocket": ["attack", .5, "Deal .5x base damage and distract an enemy skipping their next turn", "enemy"],
	"backstab": ["attack", 2, "Vanish for a turn, then next turn hit one enemy for 2x dmg. If hit before your next turn and damage is amplified by 1.5x", "self"],
	
	#endregion
	
	#region SUPPORT

	### CLERIC ###
	"blessing": ["heal", .3, "Heal a party member for 30% of their max hp", "ally"],
	"heavenly_blow": ["attack", 1, "Strike the enemy dealing Nx damage (n equals the number of party members above half health not including summons)", "enemy"],
	"heavenly_blessing": ["heal", .2, "Heal your whole party for 20% of each max health", "all_allies"],
	
	### ALCHEMIST ###
	"hearty_potion": ["heal", .3, "Heal target for 30% of their max hp", "ally"],
	"robust_potion": ["buff", .25, "Increase a party members next attack by 25%", "ally"],
	"posion_potion": ["attack", 1.5, "throw a potion at an enemy dealing 1.5x and giving the target poison for 3 turns", "enemy"],
	
	### DRUID ###
	"thorny_vines": ["attack", .5, "Ensnare an enemy in vines dealing .75x dmg and skipping their next turn", "enemy"],
	"petals_of_vitality": ["heal", .3, "Heal a party member for 30% of their max health", "ally"],
	"gaia_blessing": ["buff", .2, "Increase your entire parties dmg by 20% for 1 turns", "all_allies"],
	
	### LANDON ###
	"study_time": ["special", 1, "Use any ability of one of your other party members", "enemy"],
	"self_improvement": ["buff", .2, "Increase your attack by 20% for the rest of the floor (cannot be stacked)", "self"],
	"student_enrollment": ["special", .15, "Enroll a party member as your student increasing all their stats by 15% for the rest of the floor (can be used once per floor).", "other_ally"],
	
	#endregion
	
	#endregion
	
	#region MONSTER
	
	"weak_strike": ["attack", 1, "Strikes a party member inflicting 1x damage.", "enemy"],
	"intermediate_strike": ["attack", 1.75, "Strikes a party member inflicting 1.75x damage.", "enemy"],
	"heavy_strike": ["attack", 2.25, "Strikes a party member inflicting 2.25x damage.", "enemy"],
	"inhuman_strike": ["attack", 3, "Strikes a party member inflicting 3x damage.", "enemy"],
	
	#region CRYPT
	
	### ZOMBIE ###
	"bite": ["attack", 1, "Bites a party member inflicting 2 damage.", "enemy"],
	"scratch": ["attack", 1, "Bites a party member inflicting 2 damage.", "enemy"],
	
	### SKELETON ###
	"shoot_arrow": ["attack", 1, "Shoot an arrow at a party member inflicting 2 damage.", "enemy"],
	
	### RAIDER ###
	"shoot_bolt": ["attack", 1.25, "Shoot a bolt at a party member inflicting 1.25x damage.", "enemy"],
	"raider_axe_throw": ["attack", 1.25, "Throw an axe at a party member inflicting 1.25x damage.", "enemy"],
	"rally": ["buff", 1.5, "Organizes other monsters raising their attack by 1.5x.", "all_allies"],
	
	### MEGA KNIGHT ###
	"chivalry": ["buff", .1, "Increases attack and defense by .1 for every 10% of health lost for 1 turn.", "self"],
	"mega_heal": ["heal", .3, "Heal for 30% of max health.", "self"],
	
	#endregion
	
	#region SWAMP
	
	### GOBLIN ###
	"dagger_throw": ["attack", 1.75, "Strikes a party member inflicting 4 damage.", "enemy"],
	"poison_strike": ["attack", 1, "Attack for 1x damage and apply poison for 1 turn.", "enemy"],
	
	### ORC ###
	"hes_got_a_club": ["attack", 2, "Attack a party member for 2x damage.", "enemy"],
	"thick_hide": ["buff", 0.25, "Raise defense by 0.25 for 1 turn", "self"],
	
	### TROLL ###
	"carnage": ["buff", 2, "Increase attack by 2x for 1 turn.", "self"],
	"piercing_gaze": ["curse", 1, "Petrify party member for 1 turn.", "enemy"],
	
	### GREEN ONI ###
	"shapeshift": ["special", 1, "Use a random enemies ability.", "enemy"],
	"blunt_rage": ["buff", 2, "Increases attack by 2x for 1 turn.", "self"],
	
	#endregion
	
	#region CURSED_TOMB
	
	### PHARAOH ###
	"call_of_the_tomb": ["special", 1, "Summons a mummy as a minion.", "self"],
	"sacrificial_tomb": ["special", 0.25, "Kill all minions apply damage to all enemies (0.25x damage per minion) and wither for 1 turn.", "all_enemies"],
	
	### SCARAB BEETLE ###
	"burrow": ["buff", 0.8, "Raise defense by .8.", "self"],
	"rough_and_tumble": ["attack", 1.75, "Attack for 1.75x damage and apply confusion for 1 turn.", "enemy"],
	
	### COBRA ###
	"fang_strike": ["attack", 1.25, "Attack for 1.25x damage and apply poison for 2 turns.", "enemy"],
	"strangle": ["attack", 1, "Attack for 1x damage and apply confusion for 1 turn.", "enemy"], 
	
	### ANUBIS ACOLYTE ###
	"plague": ["curse", 1, "Forces a random curse onto the entire party for 1 turn.", "all_enemies"],
	"bloody_slash": ["attack", 2, "Attacks for 2x damage and heals half the damage dealt.", "enemy"],
	"underworld_consumption": ["attack", 1.25, "Attack for 1.25x damage and apply the curse of the undrworld until the end of combat.", "enemy"],
	
	#endregion 
	
	#region ENCHANTED_LIBRARY
		
	### GOLEM ### 
	"rock_shield": ["buff", .5, "Raise defense by .5 for 1 turn.", "self"],
	"diamond_crust": ["buff", 1, "Raise an allies defense by 1 for 1 turn.", "ally"],
	"blood_stone": ["attack", 0.75, "Attack for .75x damage, heal for .1x of damage.", "enemy"],
	
	### EVIL LIBRARIAN ###
	"dark_blessing": ["heal", .1, "Read ancient literature that restores health to allies for 10% of max health.", "all_allies"],
	"dark_restoration": ["special", .5, "Read ancient literature that revives a dead teammate at 25% of their total hp at the cost of half of max health.", "ally"],
	
	### CULTIST ###
	"deluded_worship": ["buff", .25, "Raise all ally attack by 25% and apply vulnerable", "all_allies"],
	"bloody_sacrifice": ["attack", 1, "Kill this enemy and apply all remaining health as damage to a random party member.", "enemy"],
	
	### DARK WIZARD ###
	"expanding_sources": ["special", 1, "Summons 1-2 cursed book minions.", "self"],
	"cursed_knowledge": ["curse", 1, "Destroys all cursed book minions and applies a minor curse to the entire player party (1 book = weakness(0.8x damage modifier), 2 book = slowness(30% chance to skip turn), 3 book = knowledge restriction(changes 1 random card on each character to a basic_attack)", "all_enemies"],
	"dark_fire_ball": ["attack", 2, "Attack for 2x damage and apply burn for 1 turn.", "enemy"],
	
	#endregion
	
	#region HELLSCAPE
	
	### FLYING DEMON ###
	"hot_rain": ["attack", 1.5, "Shoot fire from above, attack for 1.5x damage to all party members and apply burn.", "all_enemies"],
	"wimp": ["special", 1, "Summon a fire imp as a minion.", "self"],
	"ashes": ["special", 1.5, "Consumes all minions attack with 1.5x damage + 0.5 per minion consumed.", "enemy"],
	
	### LAVA FROG ###
	"lava_soup": ["heal", .5, "Drink lava from where you dwell, heal self for half max health.", "self"],
	"lava_splash": ["attack", 1.25, "Attack the entire party for 1.25x damage and apply burn.", "all_enemies"],
	
	### FIRE SERPENT ###
	"red_flame": ["attack", 1.25, "Shoot hot red flames at enemy party dealing 1.25x damage to every enemy and applying burn.", "all_enemies"],
	"white_flame": ["attack", 2, "Shoot white flames at one enemy dealing 2x damage and applying burn.", "enemy"],
	"green_flame": ["heal", .25, "Shoot green flames at allies and heal them for a 25% of their total health.", "all_allies"],
	
	### Hellhound ###
	"hellfire": ["attack", 2, "Attack for 2x damage and apply burn for 2 turns.", "enemy"],
	"death_omen": ["curse", 1, "Apply vunerable to all party members for 2 turns.", "all_enemies"],
	"hells_guardian": ["buff", .5, "Increase defense by .5 for 2 turns.", "self"],
	
	#endregion
	
	#region FROZEN CAVERN
	
	### FROST TROLLS ###
	"even_temper": ["buff", 2, "Increase attack by 2x for 2 turns.", "self"],
	"dominating_presence": ["curse", 1, "Petrify all party members for 1 turn.", "all_enemies"],
	"frozen_fist": ["attack", 1.5, "Attack for 1.5x damage apply frozen for 1 turn.", "enemy"],
	
	### MAMMOTH ###
	"triumphate_cry": ["curse", 1, "Apply weakness and vulnerable to all party members for 2 turns.", "all_enemies"],
	"frozen_stomp": ["attack", 1.75, "Attack for 1.75x damage and apply frozen for 1 turn.", "enemy"],
	"mobile fortress": ["buff", .5, "Increase attack and defense by 1.5x, 2x if last enemy alive.", "self"],
	
	### SABERTOOTH TIGER ###
	"mirage": ["special", 1, "Fills every available enemy slot with mirages. If the original is attacked all mirages are destroyed.", "self"],
	"cold_blooded": ["attack", 1.75, "Attacks for 1.75x damage and applies petrified for 1 turn", "enemy"],
	"frozen_fangs": ["attack", 1.5, "Attacks for 1.5x damage and applies frozen for 1 turn.", "enemy"],
	
	### YETI ###
	"blizzard": ["attack", 1.75, "Attack all party members for 1.75x damage and apply frozen.", "all_enemies"],
	"mountain_guardian": ["buff", 1, "Raise defense by .5 for 1 turn, apply weakness to all party members.", "all_enemies"],
	
	#endregion
	
	#region DRAGON DEN
	
	### DRAKE ###
	"element_burst": ["attack", 1.75, "Attack for 1.75x damage, deal random curse to player(frozen, burn, slowness, vulnerable, petrified).", "enemy"],
	"lesser_draconic_aura": ["curse", 1, "Apply weakness and vulnerable to all party members for 1 turn.", "all_enemies"],
	
	### KOBALD ###
	"group_sacrifice": ["special", 1, "if no drakes are present in the room can take away half the health of every kobold to summon a drake. Else: kills all kobolds and doubles the drakes attack and health and adds a 0.25x defense modifier.", "ally"],
	"draconic_trap": ["special", 1, "Apply a draconic trap curse to a player for 1 turn(If the cursed player attacks a draconic being they attacked themselves instead).", "ally"],
	
	### DRAGON ###
	"draconic_aura": ["curse", 1, "Reduce defense modifier of all party members to 0, apply weakness and vulnerable for 1 turn.", "all_enemies"],
	"dragon_breathe": ["attack", 2.5, "Attack for 2.5x damage and apply burn for 3 turns.", "enemy"],
	"dragon_heart": ["heal", .15, "Heal for 15% of max health, increase attack and defense damage by .5 for 1 turn.", "self"]
	
	#endregion
	
	#endregion
	
	}

var card_order: Dictionary = {
	"current_card_1": "arise",
	"current_card_2": "soul_reaping",
	"current_card_3": "spirit_sacrifice"
}

@onready var card_slots: Array = [
	$CardSlot1,
	$CardSlot2,
	$CardSlot3
]

func _ready() -> void:
	update_card_slots(card_order)
	
func update_card_slots(_cards: Dictionary):
	for i in range(card_slots.size()):
		var order_key: String = "current_card_" + str(i+1)
		var card_key: String = _cards.get(order_key, "")
		
		card_order[order_key] = card_key
		
		if card_def.has(card_key):
			card_slots[i].text = str(card_key)
		else:
			card_slots[i].text = "No card assigned"

#Returns the entire definition for a card
func get_card_data(card_key) -> Array:
	if (!card_def.has(card_key)):
		push_warning("Card not found: "+str(card_key))
		return []

	return card_def[card_key]

#Returns an individual card's type
func get_card_type(card_key) -> String:
	var data: Array = get_card_data(card_key)
	if (data.is_empty()):
		return ""
	
	return String(data[0])
	
#Returns an individual card's type
func get_card_value(card_key) -> float:
	var data: Array = get_card_data(card_key)
	if (data.is_empty()):
		return 0
	
	return float(data[1])
	
#Returns an individual card's type
func get_card_desc(card_key) -> String:
	var data: Array = get_card_data(card_key)
	if (data.is_empty()):
		return ""
	
	return String(data[2])

func use_card(owner: Node, card_key: String, _target: Array) -> void:
	
	for target in _target:
		if !card_def.has(card_key):
			push_error("Card not found: "+card_key)
			return
		
		if ((!is_instance_valid(owner) && owner.is_queued_for_deletion()) 
		|| (!is_instance_valid(target) && target.is_queued_for_deletion())):
			return
			
		var card_type: String = get_card_type(card_key)
		var effect_value: float = get_card_value(card_key)
		
		match card_type:
			
	################################### ATTACK #####################################
			
			"attack":
				
				if card_key == "explosive":
					owner.add_modifier(&"damage_multiplier", &"outgoing_damage", 2, 1)
					return
				
				var base_damage: float = owner.stats[1] * effect_value
				
				#Unique Card Calculations
				match card_key:
					"mighty_blow":
						
						if target.stats[0] < (target.max_health * 0.5):
							base_damage = owner.stats[1] * 2.0
						else:
							base_damage = owner.stats[1] * 1.5
					
					"soul_reaping":
						
						base_damage = owner.stats[1] * 0.5
				
				var damage_dealt: float = modifier_system.deal_damage(owner, target, base_damage)
				
				# Soul reaping heals based on actual damage dealt
				if card_key == "soul_reaping":
					
					owner.stats[0] = minf(owner.max_health, owner.stats[0]+damage_dealt)
				
	#################################### HEAL ######################################

			"heal":
				
				var healing: float = effect_value
				
				target.stats[0] = minf(target.max_health, target.stats[0]+healing)

	#################################### BUFF ######################################

			"buff":
				match card_key:
					
					"swordsmanship":
						owner.add_modifier(&"parry_next", &"incoming_damage", 0.0, 1)
						print("Parry Registered: ", owner.modifiers)
						
					"knights_defense":
						owner.add_modifier(&"block_next", &"incoming_damage", 0.0, 1)
						
					"dwarven_weaponry":
						owner.add_modifier(&"damage_multiplier", &"outgoing_damage", 1.1, -1)
						
	################################### CURSE ######################################
			
			"curse":
				match card_key:
					
					"taunt":
						var random_value: int = randi_range(0, 100)
						
						if random_value > 50:
							owner.add_modifier(&"taunt", &"target_selection", 0.5, -1)
							
	################################### SPECIAL ####################################
			
			"special":
				match card_key:
					
					"arise":
						#Summoning logic goes here
						pass
