extends Node

var current_level: int = 1
var current_room_type: String = "enchanted_library"
var available_room_types: Array[String] = ["crypt", "swamp", "cursed_tomb", "enchanted_library"]
var selected_party: Array[String] = ["wizard", "wizard", "wizard"]

var current_party: Array[Node] = []
