extends Resource

func init(card_name) -> Array:
	# returns [card type, value, desc]
	match card_name:
		"basic_attack":
			return ["attack", 4, "Attacks the enemy for 4 damage"]
		"heavy_attack":
			return ["attack", 8, "Attacks the enemy for 8 damage"]
		"basic_heal":
			return ["heal", 4, "Heals the target 4 health"]
		"strength_up":
			pass
		"cleanse":
			pass
	return []
