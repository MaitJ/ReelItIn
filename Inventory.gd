extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var global_variables = get_node("/root/GlobalVariables")
onready var signal_bus = get_node("/root/SignalBus")
onready var trout_count = get_node("Trout_count")
onready var pike_count = get_node("Pike_count")
onready var roach_count = get_node("Roach_count")

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_bus.connect("send_caught_fish", self, "on_send_caught_fish")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	trout_count.text = str(global_variables.trouts.size())
	pike_count.text = str(global_variables.pikes.size())
	roach_count.text = str(global_variables.roaches.size())
