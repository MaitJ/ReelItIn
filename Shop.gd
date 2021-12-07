extends Node2D

onready var signal_bus = get_node("/root/SignalBus")
onready var global_variables = get_node("/root/GlobalVariables")
onready var roach_amount = get_node("Roach_amount")
onready var pike_amount = get_node("Pike_amount")
onready var trout_amount = get_node("Trout_amount")

func _ready():
	signal_bus.connect("fish_sell", self, "on_fish_sell")
	signal_bus.connect("send_caught_fish", self, "on_send_caught_fish")
	signal_bus.connect("shop_visible", self, "on_shop_visible")
	
func on_shop_visible(state):
	print("shop should be toggled")
	visible = state

func _process(delta):
	roach_amount.text = str(global_variables.roaches.size())
	pike_amount.text = str(global_variables.pikes.size())
	trout_amount.text = str(global_variables.trouts.size())

func _on_Sell_roach_pressed():
	print("roach sold")
	signal_bus.emit_signal("fish_sell", global_variables.roaches.front())
	global_variables.roaches.pop_front()


func _on_Sell_pike_pressed():
	signal_bus.emit_signal("fish_sell", global_variables.pikes.front())
	global_variables.pikes.pop_front()


func _on_Sell_trout_pressed():
	signal_bus.emit_signal("fish_sell", global_variables.trouts.front())
	global_variables.trouts.pop_front()
