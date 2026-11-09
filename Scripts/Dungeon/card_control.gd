extends Panel

#Load the modifier script
var modifier_system = preload("res://Scripts/Dungeon/modifier_control.gd").new()

#[card type, value of card, description, intended target, class/type, locked status]
var card_def: Dictionary = {
	
	### UNIVERSAL ###
	
	"basic_attack": ["attack", 1.25, "Attacks the enemy for 3 damage", "enemy", "none", false],
	"heavy_attack": ["attack", 2, "Attacks the enemy for 6 damage", "enemy", "none", false],
	"basic_heal": ["heal", 4, "Heals the target 4 health", "self", "none", false],
	
	#region PLAYER
	
	#region TANK
	
	### KNIGHT ###
		"mighty_blow": ["attack", 1, "Strike a heavy blow to an enemy dealing 1.5x dmg, if target is below half hp deal 2x dmg.", "enemy", "knight", true],
		"swordsmanship": ["buff", 1, "Parry the next attack towards you and deal 1x dmg to the Attacker, if the attackers dmg stat is higher than it fails.", "self", "knight", true],
		"knights_defense": ["buff", 1, "Shield a party member absorbing the damage for them for 1 turn.", "other_ally", "knight", true],
	
	### DWARF ###
		"explosive": ["attack", 2, "Build a bomb that does 2x dmg to use on your next turn", "enemy", "dwarf", true],
		"dwarven_weaponry": ["buff", .1, "Upgrade a party members dmg by 10%(only can be used once per party member, lasts the remainder of the floor).", "ally", "dwarf", true],
		"dwarven_plating": ["buff", .1, "Armor a party member increasing their max health by 10%(only can be used once per party member, lasts the remainder of the floor)", "ally", "dwarf", true],
		
	### BARBARIAN ###
		"taunt": ["curse", .5, "Gain the attention of the enemies giving them a 50% chance to target you.", "all_enemies", "barbarian", true],
		"enrage": ["buff", .5, "Give a 50% chance on your next attack to hit twice.", "self", "barbarian", true],
		"drunken_rage": ["buff", 2, "Go berserk for 2 turns in a row dealing 2x dmg but lose a turn afterwards", "self", "barbarian", true],
		
	### NECROMANCER ###
		"arise": ["special", .5, "Summon a skeleton .5x dmg on your turn that attacks randomly (cannot exceed 6 total party members)", "self", "necromancer", true],
		"soul_reaping": ["attack", .5, "Deal .5x dmg to an enemy stealing health for yourself", "enemy", "necromancer", true],
		"spirit_sacrifice": ["attack", .75, "Destroy all active skeletons attacking for .75x dmg per skeleton", "enemy", "necromancer", true],
	
	#endregion
	
	#region DAMAGE

	### WIZARD ###
	"vegas_fireball": ["attack", 1, "Cast a fireball that does either 1 damage or 3x dmg", "enemy", "wizard", true],
	"fireball_maxima": ["attack", 2.5, "Cast a fireball that does .5x dmg to all enemies or has a 20% chance to do 2.5x base damage to all enemies", "all_enemies", "wizard", true],
	"magical_field": ["buff", 1, "Shield yourself in a magical bubble for 1 turns that reflects all incoming attack", "self", "wizard", true],
	
	### ARCHER ###
	"arrow_barrage": ["attack", .5, "Rain down arrows on the enemy with a 50% chance to deal 2x dmg on each enemy. Else: 1.25x damage", "all_enemies", "archer", true],
	"longshot": ["attack", 2, "Draw your bow back for a heavy shot dealing 2x dmg", "enemy", "archer", true],
	"freeze_arrow": ["attack", 1, "Does 1x dmg, 25% chance to freeze the enemy for their next turn", "enemy", "archer", true],
	
	### HUNTSMAN ###
	"mans_best_friend": ["special", 1, "Summon a companion dog with .5x huntsmans max hp that deals 1x dmg every turn to a random enemy", "self", "huntsman", true],
	"buckshot": ["attack", 2, "Fire a heavy blow from your rifle dealing 2x base damage", "enemy", "huntsman", true],
	"hunters_mark": ["buff", 1.5, "Marked enemy will take 1.5x more dmg from the dog until the enemy is defeated.", "enemy", "huntsman", true],
	
	### ROGUE ###
	"shadow_step": ["attack", .5, "Deal .5x base damage to all enemies", "all_enemies", "rogue", true],
	"pick_pocket": ["attack", .5, "Deal .5x base damage and distract an enemy skipping their next turn", "enemy", "rogue", true],
	"backstab": ["attack", 2, "Vanish for a turn, then next turn hit one enemy for 2x dmg. If hit before your next turn and damage is amplified by 1.5x", "self", "rogue", true],
	
	#endregion
	
	#region SUPPORT

	### CLERIC ###
	"blessing": ["heal", .3, "Heal a party member for 30% of their max hp", "ally", "cleric", true],
	"heavenly_blow": ["attack", 1, "Strike the enemy dealing Nx damage (n equals the number of party members above half health not including summons)", "enemy", "cleric", true],
	"heavenly_blessing": ["heal", .2, "Heal your whole party for 20% of each max health", "all_allies", "cleric", true],
	
	### ALCHEMIST ###
	"hearty_potion": ["heal", .3, "Heal target for 30% of their max hp", "ally", "alchemist", true],
	"robust_potion": ["buff", .25, "Increase a party members next attack by 25%", "ally", "alchemist", true],
	"posion_potion": ["attack", 1.5, "throw a potion at an enemy dealing 1.5x and giving the target poison for 3 turns", "enemy", "alchemist", true],
	
	### DRUID ###
	"thorny_vines": ["attack", .5, "Ensnare an enemy in vines dealing .75x dmg and skipping their next turn", "enemy", "druid", true],
	"petals_of_vitality": ["heal", .3, "Heal a party member for 30% of their max health", "ally", "druid", true],
	"gaia_blessing": ["buff", .2, "Increase your entire parties dmg by 20% for 1 turns", "all_allies", "druid", true],
	
	### LANDON ###
	"study_time": ["special", 1, "Use any ability of one of your other party members", "enemy", "landon", true],
	"self_improvement": ["buff", .2, "Increase your attack by 20% for the rest of the floor (cannot be stacked)", "self", "landon", true],
	"student_enrollment": ["special", .15, "Enroll a party member as your student increasing all their stats by 15% for the rest of the floor (can be used once per floor).", "other_ally", "landon", true],
	
	#endregion
	
	#endregion
	
	#region MONSTER
	
	"weak_strike": ["attack", 1, "Strikes a party member inflicting 1x damage.", "enemy", "none", true],
	"intermediate_strike": ["attack", 1.75, "Strikes a party member inflicting 1.75x damage.", "enemy", "none", true],
	"heavy_strike": ["attack", 2.25, "Strikes a party member inflicting 2.25x damage.", "enemy", "none", true],
	"inhuman_strike": ["attack", 3, "Strikes a party member inflicting 3x damage.", "enemy", "none", true],
	
	#region CRYPT
	
	### ZOMBIE ###
	"bite": ["attack", 1, "Bites a party member inflicting 2 damage.", "enemy", "none", true],
	"scratch": ["attack", 1, "Bites a party member inflicting 2 damage.", "enemy", "none", true],
	
	### SKELETON ###
	"shoot_arrow": ["attack", 1, "Shoot an arrow at a party member inflicting 2 damage.", "enemy", "none", true],
	
	### RAIDER ###
	"shoot_bolt": ["attack", 1.25, "Shoot a bolt at a party member inflicting 1.25x damage.", "enemy", "none", true],
	"raider_axe_throw": ["attack", 1.25, "Throw an axe at a party member inflicting 1.25x damage.", "enemy", "none", true],
	"rally": ["buff", 1.5, "Organizes other monsters raising their attack by 1.5x.", "all_allies", "none", true],
	
	### MEGA KNIGHT ###
	"chivalry": ["buff", .1, "Increases attack and defense by .1 for every 10% of health lost for 1 turn.", "self", "none", true],
	"mega_heal": ["heal", .3, "Heal for 30% of max health.", "self", "none", true],
	
	#endregion
	
	#region SWAMP
	
	### GOBLIN ###
	"dagger_throw": ["attack", 1.75, "Strikes a party member inflicting 4 damage.", "enemy", "none", true],
	"poison_strike": ["attack", 1, "Attack for 1x damage and apply poison for 1 turn.", "enemy", "none", true],
	
	### ORC ###
	"hes_got_a_club": ["attack", 2, "Attack a party member for 2x damage.", "enemy", "none", true],
	"thick_hide": ["buff", 0.25, "Raise defense by 0.25 for 1 turn", "self", "none", true],
	
	### TROLL ###
	"carnage": ["buff", 2, "Increase attack by 2x for 1 turn.", "self", "none", true],
	"piercing_gaze": ["curse", 1, "Petrify party member for 1 turn.", "enemy", "none", true],
	
	### GREEN ONI ###
	"shapeshift": ["special", 1, "Use a random enemies ability.", "enemy", "none", true],
	"blunt_rage": ["buff", 2, "Increases attack by 2x for 1 turn.", "self", "none", true],
	
	#endregion
	
	#region CURSED_TOMB
	
	### PHARAOH ###
	"call_of_the_tomb": ["special", 1, "Summons a mummy as a minion.", "self", "none", true],
	"sacrificial_tomb": ["special", 0.25, "Kill all minions apply damage to all enemies (0.25x damage per minion) and wither for 1 turn.", "all_enemies", "none", true],
	
	### SCARAB BEETLE ###
	"burrow": ["buff", 0.8, "Raise defense by .8.", "self", "none", true],
	"rough_and_tumble": ["attack", 1.75, "Attack for 1.75x damage and apply confusion for 1 turn.", "enemy", "none", true],
	
	### COBRA ###
	"fang_strike": ["attack", 1.25, "Attack for 1.25x damage and apply poison for 2 turns.", "enemy", "none", true],
	"strangle": ["attack", 1, "Attack for 1x damage and apply confusion for 1 turn.", "enemy", "none", true], 
	
	### ANUBIS ACOLYTE ###
	"plague": ["curse", 1, "Forces a random curse onto the entire party for 1 turn.", "all_enemies", "none", true],
	"bloody_slash": ["attack", 2, "Attacks for 2x damage and heals half the damage dealt.", "enemy", "none", true],
	"underworld_consumption": ["attack", 1.25, "Attack for 1.25x damage and apply the curse of the undrworld until the end of combat.", "enemy", "none", true],
	
	#endregion 
	
	#region ENCHANTED_LIBRARY
		
	### GOLEM ### 
	"rock_shield": ["buff", .5, "Raise defense by .5 for 1 turn.", "self", "none", true],
	"diamond_crust": ["buff", 1, "Raise an allies defense by 1 for 1 turn.", "ally", "none", true],
	"blood_stone": ["attack", 0.75, "Attack for .75x damage, heal for .1x of damage.", "enemy", "none", true],
	
	### EVIL LIBRARIAN ###
	"dark_blessing": ["heal", .1, "Read ancient literature that restores health to allies for 10% of max health.", "all_allies", "none", true],
	"dark_restoration": ["special", .5, "Read ancient literature that revives a dead teammate at 25% of their total hp at the cost of half of max health.", "ally", "none", true],
	
	### CULTIST ###
	"deluded_worship": ["buff", .25, "Raise all ally attack by 25% and apply vulnerable", "all_allies", "none", true],
	"bloody_sacrifice": ["attack", 1, "Kill this enemy and apply all remaining health as damage to a random party member.", "enemy", "none", true],
	
	### DARK WIZARD ###
	"expanding_sources": ["special", 1, "Summons 1-2 cursed book minions.", "self", "none", true],
	"cursed_knowledge": ["curse", 1, "Destroys all cursed book minions and applies a minor curse to the entire player party (1 book = weakness(0.8x damage modifier), 2 book = slowness(30% chance to skip turn), 3 book = knowledge restriction(changes 1 random card on each character to a basic_attack)", "all_enemies", "none", true],
	"dark_fire_ball": ["attack", 2, "Attack for 2x damage and apply burn for 1 turn.", "enemy", "none", true],
	
	#endregion
	
	#region HELLSCAPE
	
	### FLYING DEMON ###
	"hot_rain": ["attack", 1.5, "Shoot fire from above, attack for 1.5x damage to all party members and apply burn.", "all_enemies", "none", true],
	"wimp": ["special", 1, "Summon a fire imp as a minion.", "self", "none", true],
	"ashes": ["special", 1.5, "Consumes all minions attack with 1.5x damage + 0.5 per minion consumed.", "enemy", "none", true],
	
	### LAVA FROG ###
	"lava_soup": ["heal", .5, "Drink lava from where you dwell, heal self for half max health.", "self", "none", true],
	"lava_splash": ["attack", 1.25, "Attack the entire party for 1.25x damage and apply burn.", "all_enemies", "none", true],
	
	### FIRE SERPENT ###
	"red_flame": ["attack", 1.25, "Shoot hot red flames at enemy party dealing 1.25x damage to every enemy and applying burn.", "all_enemies", "none", true],
	"white_flame": ["attack", 2, "Shoot white flames at one enemy dealing 2x damage and applying burn.", "enemy", "none", true],
	"green_flame": ["heal", .25, "Shoot green flames at allies and heal them for a 25% of their total health.", "all_allies", "none", true],
	
	### Hellhound ###
	"hellfire": ["attack", 2, "Attack for 2x damage and apply burn for 2 turns.", "enemy", "none", true],
	"death_omen": ["curse", 1, "Apply vunerable to all party members for 2 turns.", "all_enemies", "none", true],
	"hells_guardian": ["buff", .5, "Increase defense by .5 for 2 turns.", "self", "none", true],
	
	#endregion
	
	#region FROZEN CAVERN
	
	### FROST TROLLS ###
	"even_temper": ["buff", 2, "Increase attack by 2x for 2 turns.", "self", "none", true],
	"dominating_presence": ["curse", 1, "Petrify all party members for 1 turn.", "all_enemies", "none", true],
	"frozen_fist": ["attack", 1.5, "Attack for 1.5x damage apply frozen for 1 turn.", "enemy", "none", true],
	
	### MAMMOTH ###
	"triumphate_cry": ["curse", 1, "Apply weakness and vulnerable to all party members for 2 turns.", "all_enemies", "none", true],
	"frozen_stomp": ["attack", 1.75, "Attack for 1.75x damage and apply frozen for 1 turn.", "enemy", "none", true],
	"mobile fortress": ["buff", .5, "Increase attack and defense by 1.5x, 2x if last enemy alive.", "self", "none", true],
	
	### SABERTOOTH TIGER ###
	"mirage": ["special", 1, "Fills every available enemy slot with mirages. If the original is attacked all mirages are destroyed.", "self", "none", true],
	"cold_blooded": ["attack", 1.75, "Attacks for 1.75x damage and applies petrified for 1 turn", "enemy", "none", true],
	"frozen_fangs": ["attack", 1.5, "Attacks for 1.5x damage and applies frozen for 1 turn.", "enemy", "none", true],
	
	### YETI ###
	"blizzard": ["attack", 1.75, "Attack all party members for 1.75x damage and apply frozen.", "all_enemies", "none", true],
	"mountain_guardian": ["buff", 1, "Raise defense by .5 for 1 turn, apply weakness to all party members.", "all_enemies", "none", true],
	
	#endregion
	
	#region DRAGON DEN
	
	### DRAKE ###
	"element_burst": ["attack", 1.75, "Attack for 1.75x damage, deal random curse to player(frozen, burn, slowness, vulnerable, petrified).", "enemy", "none", true],
	"lesser_draconic_aura": ["curse", 1, "Apply weakness and vulnerable to all party members for 1 turn.", "all_enemies", "none", true],
	
	### KOBALD ###
	"group_sacrifice": ["special", 1, "if no drakes are present in the room can take away half the health of every kobold to summon a drake. Else: kills all kobolds and doubles the drakes attack and health and adds a 0.25x defense modifier.", "ally", "none", true],
	"draconic_trap": ["special", 1, "Apply a draconic trap curse to a player for 1 turn(If the cursed player attacks a draconic being they attacked themselves instead).", "ally", "none", true],
	
	### DRAGON ###
	"draconic_aura": ["curse", 1, "Reduce defense modifier of all party members to 0, apply weakness and vulnerable for 1 turn.", "all_enemies", "none", true],
	"dragon_breathe": ["attack", 2.5, "Attack for 2.5x damage and apply burn for 3 turns.", "enemy", "none", true],
	"dragon_heart": ["heal", .15, "Heal for 15% of max health, increase attack and defense damage by .5 for 1 turn.", "self", "none", true]
	
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
				target.apply_damage_numbers(damage_dealt, false)
				
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
