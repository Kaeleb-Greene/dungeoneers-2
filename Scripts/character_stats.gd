extends Panel

@onready var upgrade_Hero = $upgradeHero
@onready var health_stat = $healthStat
@onready var healthImg = $healthImage
@onready var attackStat = $attackStat
@onready var attackimage = $attackImage

var currHero = 0
var hero1Health :int = 50
var hero1Attack :int = 20
var hero2Health :int = 30
var hero2Attack :int = 40
var hero3Health :int = 80
var hero3Attack :int = 20
var heroSelected :int = 0





func _on_hero_1_pressed() -> void:
	$healthStat.text = str(hero1Health) + " health"
	$attackStat.text = str(hero1Attack) + " attack"
	$upgradeHero.text = "Upgrade hero"
	currHero = 1
	health_stat.show()
	attackStat.show()
	attackimage.show()
	healthImg.show()

	

func _on_hero_2_pressed() -> void:
	$healthStat.text = str(hero2Health) + " health"
	$attackStat.text = str(hero2Attack) + " attack"
	currHero = 2
	$upgradeHero.text = "Upgrade hero"
	health_stat.show()
	attackStat.show()
	attackimage.show()
	healthImg.show()

func _on_hero_3_pressed() -> void:
	$healthStat.text = str(hero3Health) + " health"
	$attackStat.text = str(hero3Attack) + " attack"
	currHero = 3
	$upgradeHero.text = "Upgrade hero"
	health_stat.show()
	attackStat.show()
	attackimage.show()
	healthImg.show()


func _on_upgrade_hero_pressed() -> void:
	if heroSelected == 0:
		$upgradeHero.text = "heroSelected Test"
		print(currHero)
		if currHero == 1:
			$upgradeHero.text = "currHero 1 Test"
			hero1Health = hero1Health * 1.10
			hero1Attack = hero1Attack * 1.10
			$attackStat.text = str(hero1Attack) + " attack"
			$healthStat.text = str(hero1Health) + " health"
		elif currHero == 2:
			$upgradeHero.text = "currhero 2 test"
			$attackStat.text = str(hero2Attack * 1.10) + " attack"
			$healthStat.text = str(hero2Health * 1.10) + " health"
		elif currHero == 3:
			$upgradeHero.text = "currHero 3 test"
			$attackStat.text = str(hero3Attack * 1.10) + " attack"
			$healthStat.text = str(hero3Health * 1.10) + " health"
			#make the upgrade button red or maybe a breaking animation?
		else:
			pass # raise an error
	else:
		$upgradeHero.text = "Select a Hero!"
	
		
	


#MAKE THIS GREEN AND UNDO AFTER HOVER 

func _on_upgrade_hero_mouse_entered() -> void:
	if currHero == 1:
		$attackStat.text = str(hero1Attack * 1.10) + " attack"
		$healthStat.text = str(hero1Health * 1.10) + " health"
	if currHero == 2:
		$attackStat.text = str(hero2Attack * 1.10) + " attack"
		$healthStat.text = str(hero2Health * 1.10) + " health"
	if currHero == 3:
		$attackStat.text = str(hero2Attack * 1.10) + " attack"
		$healthStat.text = str(hero2Health * 1.10) + " health"
		
