extends Resource
class_name Transitions

const MAIN_MENU := "res://Scenes/startup_menu.tscn"
const CHARACTER_SELECTION := "res://Scenes/party_maker_menu.tscn"
const DUNGEON := "res://Scenes/dungeon.tscn"
const SHOP := "res://Scenes/shop.tscn"

func go_to_main_menu(tree: SceneTree) -> void:
	tree.change_scene_to_file(MAIN_MENU)
	
func go_to_character_selection(tree: SceneTree) -> void:
	tree.change_scene_to_file(CHARACTER_SELECTION)
	
func start_dungeon(tree: SceneTree) -> void:
	tree.change_scene_to_file(DUNGEON)

func go_to_shop(tree: SceneTree) -> void:
	tree.change_scene_to_file(SHOP)
