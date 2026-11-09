extends RefCounted

#Modifier Types: [id, trigger, value, behavior]

### |ID|                       |TRIGGER|      |VALUE|        |BEHAVIOR|

#damage_multiplier			outgoing_damage		1.5		Increase outgoing damage by 50%
#damage_taken_multiplier	incoming_damage		1.5		Increase incoming damage by 50%
#defense_bonus				incoming_damage		0.25	Increase defense by 25 percentage points
#block_next					incoming_damage		0		Negate the next incoming attack
#parry_next					incoming_damage		0		Attempt to reflect the next attack
#weakness					outgoing_damage		0.8		Reduce outgoing damage by 20%
#vulnerable					incoming_damage		1.5		Increase incoming damage by 50%

#Centralize Damage and Modifier Processing

func deal_damage(attacker: Node, target: Node, base_damage: float) -> float:
	if !is_instance_valid(attacker) || !is_instance_valid(target):
		return 0.0
	 
	if attacker.is_queued_for_deletion() || target.is_queued_for_deletion():
		return 0.0
		
	var damage: float = base_damage
	
	# ================================================================= #
	# 						 ATTACK MODIFIERS
	# ================================================================= #
	
	for i in range(attacker.modifiers.size() -1, -1, -1):
		
		var modifier: Dictionary = attacker.modifiers[i]
		
		if modifier.get("trigger") != &"outgoing_damage":
			continue
			
		match modifier.get("id"):
			&"damage_multiplier":
				damage *= float(modifier.get("value", 1.0))
	
	# ================================================================= #
	# 					TARGET REACTIVE MODIFIERS
	# ================================================================= #
	
	for i in range(target.modifiers.size() -1, -1, -1):
		var modifier: Dictionary = target.modifiers[i]
		
		if modifier.get("trigger") != &"incoming_damage":
			continue
			
		match modifier.get("id"):
			&"block_next":
				print_rich("[color=green]Attack Successfully Blocked!")
				target.consume_modifier(i)
				return 0.0
			
			&"parry_next":
				target.consume_modifier(i)
				
				if (target.stats[1] > attacker.stats[1]):
					
					var reflected_damage: float = (
						target.stats[1] * (1.0 - clampf(attacker.stats[2], 0.0, 1.0))
					)
					
					attacker.stats[0] = maxf(0.0, attacker.stats[0] - reflected_damage)
					attacker.healthbar.set_health(attacker.stats[0])
					
					print_rich("[color=green]Attack Successfully Parried!")
					
					return 0.0
				
				else:
					print_rich("[color=red]Attacker attack to high. Parry Failed!")

	# ================================================================= #
	# 					  TARGET DEFENSE MODIFIERS
	# ================================================================= #

	var defense: float = clampf(target.stats[2], 0.0, 1.0)

	for modifier in target.modifiers:
	
		if modifier.get("trigger") != &"incoming_damage":
			continue
		
		match modifier.get("id"):
			&"defense_bonus":
				defense += float(modifier.get("value", 0.0))
			
			&"defense_taken_multiplier":
				damage *= float(modifier.get("value", 1.0))
	
	# ================================================================= #
	# 					 FINAL DAMAGE CALCULATION
	# ================================================================= #
	
	defense = clampf(defense, 0.0, 1.0)
	damage *= (1.0 - defense)
	damage = maxf(0.0, damage)
	
	#Calculate actual health lost
	var actual_damage: float = minf(damage, maxf(0.0, target.stats[0]))
	
	var damage_calc = maxf(0.0, target.stats[0]-damage)
	target.stats[0] = damage_calc
	target.healthbar.set_health(damage_calc)
	
	return actual_damage
