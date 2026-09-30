extends Panel

var hero1Health :int = 50
var hero1Attack :int = 20
var hero2Health :int = 30
var hero2Attack :int = 40
var hero3Health :int = 80
var hero3Attack :int = 20





func _on_hero_1_pressed() -> void:
	$healthStat.text = str(hero1Health) + " health"
	$attackStat.text = str(hero1Attack) + " attack"

func _on_hero_2_pressed() -> void:
	$healthStat.text = str(hero2Health) + " health"
	$attackStat.text = str(hero2Attack) + " attack"


func _on_hero_3_pressed() -> void:
	$healthStat.text = str(hero3Health) + " health"
	$attackStat.text = str(hero3Attack) + " attack"
