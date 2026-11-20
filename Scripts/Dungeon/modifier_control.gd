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

func process_owner_start_of_turn_trigger(owner: Node, party_list: Array[Node], enemy_list: Array[Node]):
	if !is_instance_valid(owner):
		return
		
	if owner.is_queued_for_deletion() || owner.is_dead:
		return
		
	for character in party_list + enemy_list:
		if !is_instance_valid(character):
			continue
			
		if character.is_queued_for_deletion() || character.is_dead:
			continue
			
		for i in range(character.modifiers.size() -1, -1, -1):
			var modifier: Dictionary = character.modifiers[i]
			
			if modifier.get("source") != owner:
				continue
			
			if modifier.get("trigger") != &"start_of_owner_turn":
				continue
			
			match modifier.get("id"):
				&"explosive":
					#Save the values before consuming
					var trap_damage: float = float(modifier.get("value", 0.0))
					
					var damage: float = deal_damage(owner, character, trap_damage)
					character.apply_damage_numbers(damage)
					
					#Consume the trap
					character.consume_modifier(i)
					
			if character.is_dead:
				break

func process_start_of_turn_trigger(character: Node, trigger: StringName) -> void:
	if !is_instance_valid(character):
		return
		
	if character.is_queued_for_deletion() || character.is_dead:
		return 
	
	for i in range(character.modifiers.size() -1, -1, -1):
		var modifier: Dictionary = character.modifiers[i]
		
		match modifier.get("id"):
			&"freeze_next":
				
				character.skip_turn = true
				character.consume_modifier(i)
			
			&"petrify_next":
				
				character.skip_turn = true
				character.consume_modifier(i)
			
			&"confuse_next":
				
				character.skip_turn = true
				character.consume_modifier(i)
			
			&"slowness":
				var random = randi_range(0, 100)
				
				if random < (modifier.get("value", 0) * 100):
					character.skip_turn = true
				character.consume_modifier(i)
				
			
			&"poison_next":
				#Save the values before consuming
				var poison_damage: float = float(modifier.get("value", 0.0))
				
				var damage: float = deal_damage(null, character, poison_damage)
				character.apply_damage_numbers(damage)
				
				#Consume the trap
				character.consume_modifier(i)
			
		if character.is_dead:
			break

func deal_damage(attacker: Node, target: Node, base_damage: float) -> float:
	if !is_instance_valid(target):
		return 0.0
		
	if target.is_queued_for_deletion():
		return 0.0
	 
	if is_instance_valid(attacker) && attacker.is_queued_for_deletion():
		return 0.0
		
	var damage: float = base_damage
	var defense: float = clampf(target.stats[2], 0.0, 1.0) #range of 0.0 to 1.0
	var vulnerable: float = 1.0 #works like damage multipliers Nx damage
	var weakness: float = 1.0 #range of 0.0 to 1.0 (0.0 being no damage would be applied)
	
	# ================================================================= #
	# 						 ATTACK MODIFIERS
	# ================================================================= #
	if (is_instance_valid(attacker)):
		for i in range(attacker.modifiers.size() -1, -1, -1):
			
			var modifier: Dictionary = attacker.modifiers[i]
			
			if modifier.get("trigger") != &"outgoing_damage":
				continue
				
			match modifier.get("id"):
				&"damage_multiplier":
					damage *= float(modifier.get("value", 1.0))
					attacker.consume_modifier(i)
					
				&"drunken_rage":
					damage *= float(modifier.get("value", 1.0))
					attacker.consume_modifier(i)
				
				&"taunt":
					target = modifier.get("source", target)
					attacker.consume_modifier(i)
					
				&"weakness":
					weakness = modifier.get("value", 1.0)
					attacker.consume_modifier(i)

		# ================================================================= #
		# 					TARGET REACTIVE MODIFIERS
		# ================================================================= #
		
		for i in range(target.modifiers.size() -1, -1, -1):
			var modifier: Dictionary = target.modifiers[i]
			
			if modifier.get("trigger") != &"incoming_damage":
				continue
				
			match modifier.get("id"):
				#Defense Type
				&"block_next":
					target.consume_modifier(i)
				
				#Damage Reversal
				&"parry_next":
					target.consume_modifier(i)
					
					if (target.stats[1] > attacker.stats[1]):
						
						var reflected_damage: float = (
							target.stats[1] * (modifier.get("value", 1.0))
						)
						
						attacker.stats[0] = snapped(maxf(0.0, attacker.stats[0] - reflected_damage), 0.1)
						attacker.healthbar.set_health(snapped(attacker.stats[0], 0.1))
						attacker.check_death()
						
						return 0.0

		# ================================================================= #
		# 					  TARGET DEFENSE MODIFIERS
		# ================================================================= #
		
		for i in range(target.modifiers.size() -1, -1, -1):
			var modifier: Dictionary = target.modifiers[i]
			
			if modifier.get("trigger") != &"incoming_damage":
				continue
			
			match modifier.get("id"):
				&"defense_bonus":
					defense += snapped(float(modifier.get("value", 0.0)), 0.1)
					target.consume_modifier(i)
				
				&"vulnerable":
					vulnerable = snapped(float(modifier.get("value", 1.0)), 0.1)
					target.consume_modifier(i)
				
				&"huntersmark":
					if attacker.type == "dog_summon":
						vulnerable = snapped(float(modifier.get("value", 1.0)), 0.1)
		# ================================================================= #
		# 					 FINAL DAMAGE CALCULATION
		# ================================================================= #
		
	damage *= vulnerable
	damage *= weakness
	
	defense = clampf(defense, 0.0, 1.0)
	damage *= (1.0 - defense)
	
	damage = maxf(0.0, damage)
	
	#Calculate actual health lost
	var actual_damage: float = snapped(minf(damage, maxf(0.0, target.stats[0])), 0.1)
	
	var damage_calc = snapped(maxf(0.0, target.stats[0]-damage), 0.1)
	target.stats[0] = damage_calc
	target.healthbar.set_health(damage_calc)
	target.check_death()
	
	return actual_damage
