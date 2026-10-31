extends Panel

#Card type + Description
var card_def: Dictionary = {
	
	### UNIVERSAL ###
	
	"basic_attack": ["attack", 1.25, "Attacks the enemy for 3 damage"],
	"heavy_attack": ["attack", 2, "Attacks the enemy for 6 damage"],
	"basic_heal": ["heal", 4, "Heals the target 4 health"],
	
	#region PLAYER
	
	#region TANK
	
	### KNIGHT ###
		"mighty_blow": ["attack", 1, "Strike a heavy blow to an enemy dealing 1.5x dmg, if target is below half hp deal 2x dmg."],
		"swordsmandship": ["attack", 1, "Parry the next attack towards you and deal 1x dmg to the Attacker, if the attackers dmg stat is higher than it fails."],
		"knights_defense": ["buff", 1, "Shield a party member absorbing the damage for them."],
	
	### DWARF ###
		"explosive": ["attack", 2, "Build a bomb that does 2x dmg to use on your next turn"],
		"dwarven_weaponry": ["buff", .1, "Upgrade a party members dmg by 10%(only can be used once per party member, lasts the remainder of the floor)."],
		"dwarven plating": ["buff", .1, "Armor a party member increasing their max health by 10%(only can be used once per party member, lasts the remainder of the floor)"],
		
	### BARBARIAN ###
		"taunt": ["curse", .5, "Gain the attention of the enemies giving them a 50% chance to target you."],
		"enrage": ["buff", .5, "Give a 50% chance on your next attack to hit twice."],
		"drunken_rage": ["buff", 2, "Go berserk for 2 turns in a row dealing 2x dmg but lose a turn afterwards"],
		
	### NECROMANCER ###
		"arise": ["special", [.5], "Summon a skeleton .5x dmg on your turn that attacks randomly (cannot exceed 6 total party members)"],
		"soul_reaping": ["attack", [.5], "Deal .5x dmg to an enemy stealing health for yourself"],
		"spirit_sacriface": ["attack", [.75], "Destroy all active skeletons adding .75x dmg to your next attack per skeleton"],
	
	#endregion
	
	#region DAMAGE

	### WIZARD ###
	"vegas_fireball": ["attack", [1, 3].pick_random(), "Cast a fireball that does either 1 damage or 3x dmg"],
	"fireball_maxima": ["attack", 2.5, "Cast a fireball that does .5x dmg to an enemy or has a 20% chance to do 2.5x base damage to all enemies"],
	"magical_field": ["buff", 1, "Shield yourself in a magical bubble for 1 turns that reflects all incoming attack"],
	
	### ARCHER ###
	"arrow_barrage": ["attack", .5, "Rain down arrows on the enemy with a 50% chance to 1x dmg on each enemy"],
	"longshot": ["attack", 2, "Draw your bow back for a heavy shot dealing 2x dmg"],
	"freeze_arrow": ["attack", 1, "Does 1x dmg, 25% chance to freeze the enemy for their next turn"],
	
	### HUNTSMAN ###
	"mans_best_friend": ["special", 1, "Summon a companion dog with .5x huntsmans max hp that deals 1x dmg every turn to a random enemy"],
	"buckshot": ["attack", 2, "Fire a heavy blow from your rifle dealing 2x base damage"],
	"hunters_mark": ["buff", 1.5, "Marked enemy will take 1.5x more dmg from the dog until the enemy is defeated."],
	
	### Rogue ###
	"shadow_step": ["attack", .5, "Deal .5x base damage to all enemies"],
	"pick_pocket": ["special", .5, "Deal .5x base damage and distract an enemy skipping their next turn"],
	"backstab": ["attack", 2, "Vanish for a turn, then next turn hit one enemy for 2x dmg. If hit before your next turn and damage is amplified by 1.5x"],
	
	#endregion
	
	#region SUPPORT

	### LANDON ###
	"study_time": ["special", 1, "Use any ability of one of your other party members"],
	"self_improvement": ["buff", .2, "Increase your attack by 20% for the rest of the floor (cannot be stacked)"],
	"student_enrollment": ["special", .15, "Enroll a party member as your student increasing all their stats by 15% for the rest of the floor (can be used once per floor)."],
	
	### CLERIC ###
	"blessing": ["heal", .3, "Heal a party member for 30% of their max hp"],
	"heavenly_blow": ["attack", 1, "Strike the enemy dealing Nx damage (n equals the number of party members above half health not including summons)"],
	"heavenly_blessing": ["heal", .2, "Heal your whole party for 20% of each max health"],
	
	### ALCHEMIST ###
	"hearty_potion": ["heal", .3, "Heal target for 3% of their max hp"],
	"robust_potion": ["buff", .25, "Increase a party members next attack by 25%"],
	"hardy_potion": ["buff", 1, "Negate the next attack against a party member"],
	
	### DRUID ###
	"thorny_vines": ["attack", .5, "Ensnare an enemy in vines dealing .75x dmg and skipping their next turn"],
	"petals_of_vitality": ["heal", .3, "Heal a party member for 30% of their max health"],
	"gaia_blessing": ["buff", .2, "Increase your entire parties dmg by 20% for 1 turns"],
	
	#endregion
	
	#endregion
	
	#region MONSTER
	
	"weak_strike": ["attack", 1, "Strikes a party member inflicting 1x damage."],
	"intermediate_strike": ["attack", 1.75, "Strikes a party member inflicting 1.75x damage."],
	"heavy_strike": ["attack", 2.25, "Strikes a party member inflicting 2.25x damage."],
	"inhuman_strike": ["attack", 3, "Strikes a party member inflicting 3x damage."],
	
	#region CRYPT
	
	### ZOMBIE ###
	"bite": ["attack", 1, "Bites a party member inflicting 2 damage."],
	"scratch": ["attack", 1, "Bites a party member inflicting 2 damage."],
	
	### SKELETON ###
	"shoot_arrow": ["attack", 1, "Shoot an arrow at a party member inflicting 2 damage."],
	
	### RAIDER ###
	"shoot_bolt": ["attack", 1.25, "Shoot a bolt at a party member inflicting 1.25x damage."],
	"raider_axe_throw": ["attack", 1.25, "Throw an axe at a party member inflicting 1.25x damage."],
	"rally": ["buff", 1.5, "Organizes other monsters raising their attack by 1.5x."],
	
	### MEGA KNIGHT ###
	"chivalry": ["buff", .1, "Shoot a bolt at a party member inflicting 8 damage."],
	"mega_heal": ["heal", .3, "Self heal for 30% of max health."],
	
	#endregion
	
	#region SWAMP
	
	### GOBLIN ###
	"dagger_throw": ["attack", 1.75, "Strikes a party member inflicting 4 damage."],
	"poison_strike": ["attack", 1, "Attack for 1x damage and apply poison for 1 turn."],
	
	### ORC ###
	"hes_got_a_club": ["attack", 2, "Attack a party member for 2x damage."],
	"thick_hide": ["buff", 0.25, "Raise defense by 0.25 for 1 turn"],
	
	### TROLL ###
	"carnage": ["buff", 2, "Increase attack by 2x for 1 turn."],
	"piercing_gaze": ["curse", 1, "Petrify party member for 1 turn."],
	
	### GREEN ONI ###
	"shapeshift": ["special", 1, "Use a random enemies ability."],
	"blunt_rage": ["buff", 2, "Increases attack by 2x for 1 turn."],
	
	#endregion
	
	#region CURSED_TOMB
	
	### PHARAOH ###
	"call_of_the_tomb": ["special", 1, "Summons a mummy as a minion."],
	"sacrificial_tomb": ["special", 0.25, "Kill all minions apply damage to all enemies (0.25x damage per minion) and wither for 1 turn."],
	
	### SCARAB BEETLE ###
	"burrow": ["buff", 0.2, "The next attack against this enemy does 0.2x damage."],
	"rough_and_tumble": ["attack", 1.75, "Attack for 1.75x damage and apply confusion for 1 turn."],
	
	### COBRA ###
	"fang_strike": ["attack", 1.25, "Attack for 1.25x damage and apply poison for 2 turns."],
	"strangle": ["attack", 1, "Attack for 1x damage and apply confusion for 1 turn."], 
	
	### ANUBIS ACOLYTE ###
	"plague": ["curse", 1, "Forces a random curse onto the entire party for 1 turn."],
	"bloody_slash": ["attack", 2, "Attacks for 2x damage and heals half the damage dealt."],
	"underworld_consumption": ["attack", 1.25, "Attack for 1.25x damage and apply the curse of the undrworld until the end of combat."],
	
	#endregion 
	
	#region ENCHANTED_LIBRARY
		
	### GOLEM ### 
	"rock_shield": ["buff", .5, "Raise defense by .5."],
	"diamond_crust": ["buff", 1, "Next attack does no damage (defense is 1)"],
	"blood_stone": ["attack", 0.75, "Attack for .75x damage, heal for .1x of damage."],
	
	### EVIL LIBRARIAN ###
	"dark_blessing": ["heal", .1, "Read ancient literature that restores health to allies for 10% of max health."],
	"dark_restoration": ["special", .5, "Read ancient literature that revives a dead teammate at 25% of their total hp at the cost of half of max health."],
	
	### CULTIST ###
	"deluded_worship": ["buff", .25, "Raise all enemy attack by 25% and apply vulnerable"],
	"bloody_sacrifice": ["attack", 1, "Kill this enemy and apply all remaining health as damage to a random party member."],
	
	### DARK WIZARD ###
	"expanding_sources": ["special", 1, "Summons 1-2 cursed book minions."],
	"cursed_knowledge": ["curse", 1, "Destroys all cursed book minions and applies a minor curse to the entire player party (1 book = weakness(0.8x damage modifier), 2 book = slowness(30% chance to skip turn), 3 book = knowledge restriction(changes 1 random card on each character to a basic_attack)"],
	"dark_fire_ball": ["attack", 2, "Attack for 2x damage and apply burn for 1 turn."],
	
	#endregion
	
	#region HELLSCAPE
	
	### FLYING DEMON ###
	"hot_rain": ["attack", 1.5, "Shoot fire from above, attack for 1.5x damage to all party members and apply burn."],
	"wimp": ["special", 1, "Summon a fire imp as a minion."],
	"ashes": ["special", 1.5, "Consumes all minions attack with 1.5x damage + 0.5 per minion consumed."],
	
	### LAVA FROG ###
	"lava_soup": ["heal", .5, "Drink lava from where you dwell, heal self for half max health."],
	"lava_splash": ["attack", 1.25, "Attack the entire party for 1.25x damage and apply burn."],
	
	### FIRE SERPENT ###
	"red_flame": ["attack", 1.25, "Shoot hot red flames at enemy party dealing 1.25x damage to every enemy and applying burn."],
	"white_flame": ["attack", 2, "Shoot white flames at one enemy dealing 2x damage and applying burn."],
	"green_flame": ["heal", .25, "Shoot green flames at allies and heal them for a 25% of their total health."],
	
	### Hellhound ###
	"hellfire": ["attack", 2, "Attack for 2x damage and apply burn for 2 turns."],
	"death_omen": ["curse", 1, "Apply vunerable to all party members for 2 turns."],
	"hells_guardian": ["buff", .5, "Increase defense by .5 for 2 turns."],
	
	#endregion
	
	#region FROZEN CAVERN
	
	### FROST TROLLS ###
	"even_temper": ["buff", 2, "Increase attack by 2x for 2 turns."],
	"dominating_presence": ["curse", 1, "Petrify all party members for 1 turn."],
	"frozen_fist": ["attack", 1.5, "Attack for 1.5x damage apply frozen for 1 turn."],
	
	### MAMMOTH ###
	"triumphate_cry": ["curse", 1, "Apply weakness and vulnerable to all party members for 2 turns."],
	"frozen_stomp": ["attack", 1.75, "Attack for 1.75x damage and apply frozen for 1 turn."],
	"mobile fortress": ["buff", .5, "Increase attack and defense by 1.5x, 2x if last enemy."],
	
	### SABERTOOTH TIGER ###
	"mirage": ["special", 1, "Fills every available enemy slot with mirages. If the original is attacked all mirages are destroyed."],
	"cold_blooded": ["attack", 1.75, "Attacks for 1.75x damage and applies petrified for 1 turn"],
	"frozen_fangs": ["attack", 1.5, "Attacks for 1.5x damage and applies frozen for 1 turn."],
	
	### YETI ###
	"blizzard": ["attack", 1.75, "Attack all party members for 1.75x damage and apply frozen."],
	"mountain_guardian": ["buff", 1, "Raise defense by .5 for 1 turn, apply weakness to all party members."],
	
	#endregion
	
	#region DRAGON DEN
	
	### DRAKE ###
	"element_burst": ["attack", 1.75, "Attack for 1.75x damage, deal random curse to player(frozen, burn, slowness, vulnerable, petrified)."],
	"lesser_draconic_aura": ["curse", 1, "Apply weakness and vulnerable to all party members for 1 turn."],
	
	### KOBALD ###
	"group_sacrifice": ["special", 1, "if no drakes are present in the room can take away half the health of every kobold to summon a drake. Else: kills all kobolds and doubles the drakes attack and health and adds a 0.25x defense modifier."],
	"draconic_trap": ["special", 1, "Apply a draconic trap curse to a player for 1 turn(If the cursed player attacks a draconic being they attacked themselves instead)."],
	
	### DRAGON ###
	"draconic_aura": ["curse", 1, "Reduce defense modifier of all party members to 0, apply weakness and vulnerable for 1 turn."],
	"dragon_breathe": ["attack", 2.5, "Attack for 2.5x damage and apply burn for 3 turns."],
	"dragon_heart": ["heal", .15, "Heal for 15% of max health, increase attack and defense damage by .5 for 1 turn."]
	
	#endregion
	
	#endregion
	
	}

var card_order: Dictionary = {
	"current_card_1": "basic_attack",
	"current_card_2": "heavy_attack",
	"current_card_3": "basic_heal"
}

@onready var card_slots: Array = [
	$CardSlot1,
	$CardSlot2,
	$CardSlot3
]

func _ready() -> void:
	update_card_slots()
	
func update_card_slots():
	for i in range(card_slots.size()):
		var order_key: String = "current_card_" + str(i+1)
		var card_key: String = card_order.get(order_key, "")
	
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

func use_card(owner, card_key, target):
	var card_type: String = get_card_type(card_key)
	var effect_value: int = get_card_value(card_key)
	
	match card_type:
		"attack":
			target.stats[0] -= (owner.stats[1]*effect_value)
		"heal":
			target.stats[0] += effect_value
		"buff":
			match card_key:
				"rally":
					pass
		"curse":
			pass
		"special":
			pass
