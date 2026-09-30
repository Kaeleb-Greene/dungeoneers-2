extends Panel

@onready var upgrade_Hero = $upgradeHero
var currHero = 0
var hero1Health :int = 50
var hero1Attack :int = 20
var hero2Health :int = 30
var hero2Attack :int = 40
var hero3Health :int = 80
var hero3Attack :int = 20





func _on_hero_1_pressed() -> void:
	$healthStat.text = str(hero1Health) + " health"
	$attackStat.text = str(hero1Attack) + " attack"
	var currHero = 1

func _on_hero_2_pressed() -> void:
	$healthStat.text = str(hero2Health) + " health"
	$attackStat.text = str(hero2Attack) + " attack"
	var currHero = 2


func _on_hero_3_pressed() -> void:
	$healthStat.text = str(hero3Health) + " health"
	$attackStat.text = str(hero3Attack) + " attack"
	var currHero = 3


func _on_upgrade_hero_pressed() -> void:
		hero1Health = hero1Health * 1.10
		hero1Attack = hero1Attack * 1.10
		$attackStat.text = str(hero1Attack) + " attack"
		$healthStat.text = str(hero1Health) + " health"
		
		





func _on_upgrade_hero_mouse_entered() -> void:
	if currHero == 1:
		$attackStat.text = str(hero1Attack * 1.10) + " attack"
		$healthStat.text = str(hero1Health * 1.10) + " health"
