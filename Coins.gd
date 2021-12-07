extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var coin_amount = get_node("CoinCount")
onready var signal_bus = get_node("/root/SignalBus")

var gold_amount = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	signal_bus.connect("fish_sell", self, "on_fish_sell")

func on_fish_sell(fish):
	gold_amount += fish.Coins

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coin_amount.text = str(gold_amount)
