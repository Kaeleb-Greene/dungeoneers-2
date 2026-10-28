extends Panel

@onready var upgrade_Hero = $upgradeHero
@onready var health_stat = $healthStat
@onready var attackStat = $attackStat
@onready var abilityText = $upgrades/abilityUpgrade1

var upgradeToken = 1
var currHero = 0
var hero1Health :int = 50
var hero1Attack :int = 20
var hero2Health :int = 30
var hero2Attack :int = 40
var hero3Health :int = 80
var hero3Attack :int = 20
var heroSelected :int = 0





func _on_hero_1_pressed() -> void:
	$healthStat.text = str(hero1Health)
	$attackStat.text = str(hero1Attack)
	$upgradeHero.text = "Upgrade hero"
	currHero = 1
	health_stat.show()
	attackStat.show()

	

func _on_hero_2_pressed() -> void:
	$healthStat.text = str(hero2Health)
	$attackStat.text = str(hero2Attack)
	currHero = 2
	$upgradeHero.text = "Upgrade hero"
	health_stat.show()
	attackStat.show()

func _on_hero_3_pressed() -> void:
	$healthStat.text = str(hero3Health)
	$attackStat.text = str(hero3Attack)
	currHero = 3
	$upgradeHero.text = "Upgrade hero"
	health_stat.show()
	attackStat.show()



func _on_upgrade_hero_pressed() -> void:
	if heroSelected == 0:
		if currHero == 1 && upgradeToken == 1:
			hero1Health = hero1Health * 1.10
			hero1Attack = hero1Attack * 1.10
			$attackStat.text = str(hero1Attack)
			$healthStat.text = str(hero1Health)
			upgradeToken = 0
			$upgradeTokens.text = str(upgradeToken) + " upgrade tokens"
		elif currHero == 2 && upgradeToken == 1:
			hero2Attack = hero2Attack * 1.10
			hero2Health = hero2Health * 1.10
			$attackStat.text = str(hero2Attack)
			$healthStat.text = str(hero2Health)
			upgradeToken = 0
			$upgradeTokens.text = str(upgradeToken) + " upgrade tokens"
		elif currHero == 3 && upgradeToken == 1:
			hero3Attack = hero3Attack * 1.10
			hero3Health = hero3Health * 1.10
			$attackStat.text = str(hero3Attack)
			$healthStat.text = str(hero3Health)
			upgradeToken = 0
			$upgradeTokens.text = str(upgradeToken) + " upgrade tokens"
			#make the upgrade button red or maybe a breaking animation?
		else: 
			$upgradeHero.text = "No tokens left!"
			$upgradeTokens.modulate = Color("c22200")
			$upgradeHero.modulate = Color("c22200")
			await get_tree().create_timer(1.0).timeout 
			$upgradeTokens.modulate = Color("ffff")
			await get_tree().create_timer(1.0).timeout 
			$upgradeTokens.modulate = Color("c22200")
			await get_tree().create_timer(1.0).timeout 
			$upgradeTokens.modulate = Color("ffff")
			$upgradeHero.modulate = Color("ffff")
			$upgradeHero.text = "Upgrade hero"
			pass # raise an error
	else:
		$upgradeHero.text = "Select a Hero!"
	
		
	


#MAKE THIS GREEN AND UNDO AFTER HOVER 

func _on_upgrade_hero_mouse_entered() -> void:
	if currHero == 1 && upgradeToken == 1:
		$attackStat.text = str(hero1Attack * 1.10)
		$healthStat.text = str(hero1Health * 1.10)
		$attackStat.modulate = Color("00ff8c")
		$healthStat.modulate = Color("00ff8c")
	if currHero == 2 && upgradeToken == 1:
		$attackStat.text = str(hero2Attack * 1.10)
		$healthStat.text = str(hero2Health * 1.10)
		$attackStat.modulate = Color("00ff8c")
		$healthStat.modulate = Color("00ff8c")
	if currHero == 3 && upgradeToken == 1:
		$attackStat.text = str(hero3Attack * 1.10)
		$healthStat.text = str(hero3Health * 1.10)
		$attackStat.modulate = Color("00ff8c")
		$healthStat.modulate = Color("00ff8c")
		


func _on_upgrade_hero_mouse_exited() -> void:
	if currHero == 1:
		$attackStat.text = str(hero1Attack)
		$healthStat.text = str(hero1Health)
		$attackStat.modulate = Color("ffffff")
		$healthStat.modulate = Color("ffffff")
	if currHero == 2:
		$attackStat.text = str(hero2Attack)
		$healthStat.text = str(hero2Health)
		$attackStat.modulate = Color("ffffff")
		$healthStat.modulate = Color("ffffff")
	if currHero == 3:
		$attackStat.text = str(hero3Attack)
		$healthStat.text = str(hero3Health)
		$attackStat.modulate = Color("ffffff")
		$healthStat.modulate = Color("ffffff")


func _on_ability_upgrade_1_pressed() -> void:
	if currHero == 1 && upgradeToken == 1:
		#get rid of this if statement and change it to putting
		#the ability text to your inventory or smthin.
		upgradeToken = 0
	elif currHero == 2 && upgradeToken == 1:
		upgradeToken = 0
	elif currHero == 3 && upgradeToken == 1:
		upgradeToken = 0
	else:
			var abilitySave = abilityText.text
			abilityText.text = "No tokens left!"
			$upgradeTokens.modulate = Color("c22200")
			abilityText.modulate = Color("c22200")
			await get_tree().create_timer(1.0).timeout 
			$upgradeTokens.modulate = Color("ffff")
			await get_tree().create_timer(1.0).timeout 
			$upgradeTokens.modulate = Color("c22200")
			await get_tree().create_timer(1.0).timeout 
			$upgradeTokens.modulate = Color("ffff")
			abilityText.modulate = Color("ffff")
			abilityText.text =  str(abilitySave) + " "
		
			
