extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var signal_bus = get_node("/root/SignalBus")
onready var roach_amount = get_node("Roach_amount")
onready var pike_amount = get_node("Pike_amount")
onready var trout_amount = get_node("Trout_amount")


# Called when the node enters the scene tree for the first time.
func _ready():
	signal_bus.connect("fish_sell", self, "on_fish_sell")
	for button in get_tree().get_nodes_in_group("Sell_buttons"):
		button.connect("pressed", self, "_sell_button_pressed", [button])
	pass # Replace with function body.

func on_fish_sell(fish):
	signal_bus.gold_amount += fish.Coins

func _sell_button_pressed():
	on_fish_sell(fish)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
