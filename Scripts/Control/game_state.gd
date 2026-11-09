extends Node

var current_level: int = 1
var current_room_type: String = "crypt"
var available_room_types: Array[String] = ["crypt", "swamp", "cursed_tomb", "enchanted_library", "hellscape", "frozen_cavern", "dragons_den"]
var selected_party: Array[String] = ["wizard", "wizard", "wizard"]
