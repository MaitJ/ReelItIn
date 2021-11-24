extends Node

var game_data = {}

func _ready():
	var game_data_file = File.new()
	game_data_file.open("res://item_data.json", File.READ)
	var game_data_json = JSON.parse(game_data_file.get_as_text())
	game_data_file.close()
	game_data = game_data_json.result
