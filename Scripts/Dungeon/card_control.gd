extends Panel

#Load the modifier script
var modifier_system = preload("res://Scripts/Dungeon/modifier_control.gd").new()
@onready var COMBAT = get_parent()

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
		"explosive": ["curse", 2.0, "Build a bomb that does 2x dmg to the enemy on its next turn", "enemy", "dwarf", true],
		"dwarven_weaponry": ["buff", 1.5, "Increase a party members attack by 1.5x for 1 turn.", "ally", "dwarf", true],
		"dwarven_plating": ["buff", .75, "Increase a party members defense by .75x for 1 turn", "ally", "dwarf", true],
		
	### BARBARIAN ###
		"taunt": ["curse", .75, "Gain the attention of the enemies giving them a 75% chance to target you.", "all_enemies", "barbarian", true],
		"enrage": ["attack", 1.5, "Attack with 1.5x damage and a 30% chance to attack a second time.", "enemy", "barbarian", true],
		"drunken_rage": ["curse", 2, "Go berserk dealing 2x dmg for the next 2 attacks, but become petrified afterwards", "self", "barbarian", true],
		
	### NECROMANCER ###
		"arise": ["special", .5, "Summon a skeleton .5x dmg on your turn that attacks randomly (cannot exceed 6 total party members)", "self", "necromancer", true],
		"soul_reaping": ["attack", .5, "Deal .5x dmg to an enemy stealing health for yourself", "enemy", "necromancer", true],
		"spirit_sacrifice": ["attack", 1, "Destroy all active skeletons attacking for 1x damage + 1.5x dmg per skeleton", "enemy", "necromancer", true],
	
	#endregion
	
	#region DAMAGE

	### WIZARD ###
	"vegas_fireball": ["attack", 3, "Cast a fireball that does either 1 damage or 3x dmg", "enemy", "wizard", true],
	"fireball_maxima": ["attack", 2.5, "Cast a fireball that does .5x dmg to all enemies or has a 20% chance to do 2.5x base damage to all enemies", "all_enemies", "wizard", true],
	"magical_field": ["buff", 1, "Shield yourself or an ally in a magical bubble for 1 turn that reflects all incoming attack", "ally", "wizard", true],
	
	### ARCHER ###
	"arrow_barrage": ["attack", .25, "Rain down arrows on the enemy with a 30% chance to deal 2x dmg on each enemy. Else: 1.25x damage", "all_enemies", "archer", true],
	"longshot": ["attack", 2, "Draw your bow back for a heavy shot dealing 2x dmg", "enemy", "archer", true],
	"freeze_arrow": ["attack", 1, "Does 1x dmg, 25% chance to freeze the enemy for their next turn", "enemy", "archer", true],
	
	### HUNTSMAN ###
	"mans_best_friend": ["special", 1, "Summon a companion dog with .5x huntsmans max hp that deals 1x dmg every turn to a random enemy", "self", "huntsman", true],
	"buckshot": ["attack", 2, "Fire a heavy blow from your rifle dealing 2x base damage", "enemy", "huntsman", true],
	"hunters_mark": ["curse", 1.5, "Marked enemy will take 1.5x more dmg from the dog until the enemy is defeated.", "enemy", "huntsman", true],
	
	### ROGUE ###
	"shadow_step": ["attack", .75, "Deal .75x base damage to all enemies", "all_enemies", "rogue", true],
	"pick_pocket": ["attack", 1, "Deal 1x base damage and distract an enemy skipping their next turn", "enemy", "rogue", true],
	"backstab": ["buff", 2.5, "Vanish for a turn, then next turn hit one enemy for 2.5x dmg. If hit before your next turn and enemy damage is amplified by 1.5x", "self", "rogue", true],
	
	#endregion
	
	#region SUPPORT

	### CLERIC ###
	"blessing": ["heal", 1.5, "Heal a party member for 50% of their max hp", "ally", "cleric", true],
	"heavenly_blow": ["attack", 1, "Strike the enemy dealing Nx damage (n equals the number of party members above half health not including summons)", "enemy", "cleric", true],
	"heavenly_blessing": ["heal", 1.25, "Heal your whole party for 25% of each max health", "all_allies", "cleric", true],
	
	### ALCHEMIST ###
	"hearty_potion": ["heal", 1.50, "Heal target for 50% of their max hp", "ally", "alchemist", true],
	"robust_potion": ["buff", 1.25, "Increase a party members next attack by 25%", "ally", "alchemist", true],
	"poison_potion": ["attack", 1.5, "throw a potion at an enemy dealing 1.5x and giving the target poison for 3 turns", "enemy", "alchemist", true],
	
	### DRUID ###
	"thorny_vines": ["attack", .75, "Ensnare an enemy in vines dealing .75x dmg and skipping their next turn", "enemy", "druid", true],
	"petals_of_vitality": ["heal", 1.5, "Heal a party member for 50% of their max health", "ally", "druid", true],
	"gaia_blessing": ["buff", 1.3, "Increase your entire parties dmg by 30% for 1 turns", "all_allies", "druid", true],
	
	### LANDON ###
	"study_time": ["special", 2.0, "Use a random attack ability with double damage.", "enemy", "landon", true],
	"self_improvement": ["buff", 1.5, "Increase your attack and defense by 50% for 1 turn.", "self", "landon", true],
	"student_enrollment": ["buff", 1.3, "Enroll a party member as your student increasing all their stats by 30% for 2 turns.", "other_ally", "landon", true],
	
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

#processes modifiers at the start of the turn
func process_start_of_turn(character: Node) -> void:
	modifier_system.process_start_of_turn_trigger(character, &"start_of_turn")

func process_owner_start_of_turn(character: Node, party_queue: Array[Node], enemy_queue: Array[Node]) -> void:
	modifier_system.process_owner_start_of_turn_trigger(character, party_queue, enemy_queue)

func use_card(owner: Node, card_key: String, _target: Array, all_enemies: Array[Node], all_party: Array[Node]) -> bool:
	
	var card_type: String = get_card_type(card_key)
	var effect_value: float = get_card_value(card_key)
	var random: int = randi_range(1, 100) #Determines chance based card values
	
	var applied: bool = false # checks whether a card has been used
	
	for i in range(_target.size()):
		var target = _target[i]
		if !card_def.has(card_key):
			push_error("Card not found: "+card_key)
			return false
		
		if (!is_instance_valid(owner) || owner.is_queued_for_deletion()):
			return false
			 
		if (!is_instance_valid(target) || target.is_queued_for_deletion()):
			continue
			
		match card_type:
			
	################################### ATTACK #####################################
			
			"attack":
				var base_damage: float = owner.stats[1] * effect_value
				
				#Unique Card Calculations
				match card_key:
					"mighty_blow":
						if target.stats[0] < (target.max_health * 0.5):
							base_damage = owner.stats[1] * (effect_value+1.0)
						else:
							base_damage = owner.stats[1] * (effect_value+.5)
					
					"soul_reaping":
						base_damage = owner.stats[1] * 0.5
					
					"vegas_fireball":
						if (random <= 50): #50% chance
							base_damage = owner.stats[1] * (effect_value/12) #0.25
						else:
							base_damage = owner.stats[1] * effect_value
					
					"fireball_maxima":
						if random <= 20:
							base_damage = owner.stats[1] * effect_value
						else:
							base_damage = owner.stats[1] * (effect_value/5)
							
					"arrow_barrage":
						if random <= 30: #30% chance
							base_damage = owner.stats[1] * (effect_value*8) #2x
						else:
							base_damage = owner.stats[1] * (effect_value*5) #1.25x
					
					"longshot":
						base_damage = owner.stats[1] * effect_value
						
					"freeze_arrow":
						base_damage = owner.stats[1] * effect_value
						
						if random <= 25: #25% chance
							target.add_modifier(&"freeze_next", &"start_of_turn", effect_value, 1, 1, owner)
					
					"heavenly_blow":
						var holy_power: float = 0.0
						
						for character in all_party:
							if (character.stats[0] >= (character.max_health/2)):
								holy_power += 1.0
						
						if (holy_power <= 0.0):
							holy_power = 1.0
						
						base_damage = owner.stats[1] * (effect_value*holy_power)
						
					"poison_potion":
						base_damage = owner.stats[1] * effect_value
						
						target.add_modifier(&"poison_next", &"start_of_turn", owner.stats[1]*effect_value, 3, -1, owner)
						applied = true
					
					"buckshot":
						base_damage = owner.stats[1] * effect_value
					
					"shadow_step":
						base_damage = owner.stats[1] * effect_value
					
					"pick_pocket":
						base_damage = owner.stats[1] * effect_value
						target.add_modifier(&"confuse_next", &"start_of_turn", effect_value, 1, 1, owner)
					
					"thorny_vines":
						base_damage = owner.stats[1] * effect_value
						target.add_modifier(&"petrify_next", &"start_of_turn", effect_value, 1, 1, owner)
					
					"enrage":
						base_damage = owner.stats[1] * effect_value
						
						if random <= 30:
							var damage_dealt: float = modifier_system.deal_damage(owner, target, base_damage)
							target.apply_damage_numbers(damage_dealt, false)
					
					"spirit_sacrifice":
						var skeleton_kills: float = 0.0
						var kill_list: Array = []
						
						for j in range(all_party.size()):
							var skelly = all_party[j]
							if skelly.type == "skeleton_summon":
								print("SKELLY")
								kill_list.append(skelly)
								skeleton_kills += 1.5
								
						for kill in kill_list:
							modifier_system.deal_damage(owner, kill, base_damage*10000)
						
						base_damage = owner.stats[1] * (effect_value+skeleton_kills)
						print(base_damage)
					
				var damage_dealt: float = modifier_system.deal_damage(owner, target, base_damage)
				target.apply_damage_numbers(damage_dealt, false)
				applied = true
				
				# Soul reaping heals based on actual damage dealt
				if card_key == "soul_reaping":
					
					var healing = snapped(minf(owner.max_health, owner.stats[0]+damage_dealt), 0.1)
					owner.heal(healing)
					owner.healthbar.set_health(owner.stats[0])
	#################################### HEAL ######################################

			"heal":
				match card_key:
					
					"blessing":
						var healing: float = effect_value
						target.heal(healing)
						target.healthbar.set_health(target.stats[0])
						applied = true
					
					"heavenly_blessing":
						var healing: float = effect_value
						target.heal(healing)
						target.healthbar.set_health(target.stats[0])
						applied = true
						
					"hearty_potion":
						var healing: float = effect_value
						target.heal(healing)
						target.healthbar.set_health(target.stats[0])
						applied = true
					
					"petals_of_vitality":
						var healing: float = effect_value
						target.heal(healing)
						target.healthbar.set_health(target.stats[0])
						applied = true
					
	#################################### BUFF ######################################

			"buff":
				match card_key:
					
					#Parry Type Buffs
					"swordsmanship":
						target.add_modifier(&"parry_next", &"incoming_damage", effect_value, 1, 1, owner)
						applied = true
					
					"magical_field":
						target.add_modifier(&"parry_next", &"incoming_damage", effect_value, 1, 1, owner)
						applied = true
					
					#Defense Type Buffs
					"knights_defense":
						target.add_modifier(&"block_next", &"incoming_damage", effect_value, 1, -1, owner)
						applied = true
						
					"dwarven_plating":
						target.add_modifier(&"defense_bonus", &"incoming_damage", effect_value, 1, -1, owner)
						applied = true
					
					"self_improvement":
						target.add_modifier(&"defense_bonus", &"incoming_damage", effect_value-1.0, 1, -1, owner)
						target.add_modifier(&"damage_multiplier", &"outgoing_damage", effect_value, 1, -1, owner)
						applied = true
						
					"student_enrollment":
						target.add_modifier(&"defense_bonus", &"incoming_damage", effect_value-1.0, 2, 2, owner)
						target.add_modifier(&"damage_multiplier", &"outgoing_damage", effect_value, 2, 2, owner)
						applied = true
					
					#Attack Type Buffs
					"dwarven_weaponry":
						target.add_modifier(&"damage_multiplier", &"outgoing_damage", effect_value, 1, -1, owner)
						applied = true
						
					"robust_potion":
						target.add_modifier(&"damage_multiplier", &"outgoing_damage", effect_value, 1, -1, owner)
						applied = true
						
					"backstab":
						target.add_modifier(&"damage_multiplier", &"outgoing_damage", effect_value, 1, 1, owner)
						target.add_modifier(&"vulnerable", &"incoming_damage", effect_value-1.0, 1, 1, owner)
						applied = true
						
					"gaia_blessing":
						target.add_modifier(&"damage_multiplier", &"outgoing_damage", effect_value, 1, -1, owner)
						applied = true
					
	################################### CURSE ######################################
			
			"curse":
				match card_key:
					
					"explosive":
						target.add_modifier(&"explosive", &"start_of_owner_turn", owner.stats[1]*effect_value, 1, 1, owner)
						applied = true
					
					"hunters_mark":
						target.add_modifier(&"huntersmark", &"incoming_damage", effect_value, -1, -1, owner)
						applied = true
					
					"drunken_rage":
						target.add_modifier(&"drunken_rage", &"outgoing_damage", effect_value, 2, -1, owner)
						applied = true
						
					"taunt":
						if random <= 75:
							target.add_modifier(&"taunt", &"outgoing_damage", effect_value, 1, 1, owner)
						applied = true
					
	################################### SPECIAL ####################################
			
			"special":
				match card_key:
					
					"study_time":
						var available_cards: Array = []
						
						for card in card_def:
							var _type = get_card_type(card)
							if _type == "attack":
								available_cards.append(card)
						
						owner.add_modifier(&"damage_multiplier", &"outgoing_damage", effect_value, 1, 1, owner)
						
						var card_choice = available_cards.pick_random()
						print("Landon Used: ", card_choice)
						use_card(owner, card_choice, _target, all_enemies, all_party)
						
						applied = true
						
					"arise":
						COMBAT.spawn_party_summon("skeleton_summon")
						applied = true
						
					"mans_best_friend":
						COMBAT.spawn_party_summon("dog_summon")
						applied = true
						
	return applied
