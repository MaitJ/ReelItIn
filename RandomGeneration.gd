extends Node

onready var signal_bus = get_node("/root/SignalBus")
onready var game_data = get_node('/root/GameData')

func _ready():
	signal_bus.connect("fish_caught", self, "_item_generation")

func _item_generation():
	print("fish_caught signal received")
	var new_item
	new_item = _item_determine_rarity()
	print(new_item)
	##siia oleks signaali/funktsiooni vaja, mis toob ette menüü
	signal_bus.emit_signal("fish_popup", new_item)

func _item_determine_rarity():
	var rarity_scope_array = []
	var new_item_type
	var item_types = game_data.game_data
	
	randomize()
	var random_float = randf()

	if random_float < 0.7: #Common fish
		for i in item_types.size():
			if item_types[i].RarityWeight == "Common":
				rarity_scope_array.append(item_types[i])

	elif random_float < 0.95: #Uncommon fish
		for i in item_types.size():
			if item_types[i].RarityWeight == "Uncommon":
				rarity_scope_array.append(item_types[i])

	else: #Rare fish
		for i in item_types.size():
			if item_types[i].RarityWeight == "Rare":
				rarity_scope_array.append(item_types[i])

	new_item_type = rarity_scope_array[randi() % rarity_scope_array.size()]
	return new_item_type
